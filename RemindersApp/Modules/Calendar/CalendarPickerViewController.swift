//
//  CalendarPickerViewController.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/27/21.
//

import UIKit


// MARK: - Thanks to:
// https://www.raywenderlich.com/10787749-creating-a-custom-calendar-control-for-ios
class CalendarPickerViewController: UIViewController {

    // MARK: - Views

    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var headerView = CalendarPickerHeaderView { [weak self] in
        guard let self = self else { return }

        self.dismiss(animated: true)
    }

    private lazy var footerView = CalendarPickerFooterView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }

            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
        })

    // MARK: - Calendar Data Values

    private let selectedDate: Date
    private var baseDate: Date {
        didSet {
            self.days = self.generateDaysInMonth(for: self.baseDate)
            self.collectionView.reloadData()
            self.headerView.baseDate = self.baseDate
        }
    }

    // MARK: - Properties

    private lazy var days = self.generateDaysInMonth(for: baseDate)

    private var numberOfWeeksInBaseDate: Int {
        self.calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    private let selectedDateChanged: ((Date) -> Void)
    private let calendar = Calendar(identifier: .gregorian)

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    // MARK: Init

    init(baseDate: Date,
         selectedDateChanged: @escaping ((Date) -> Void)) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged

        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.definesPresentationContext = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemGroupedBackground

        view.addSubview(self.dimmedBackgroundView)
        view.addSubview(self.collectionView)
        view.addSubview(self.headerView)
        view.addSubview(self.footerView)

        var constraints = [
            self.dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            self.dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        constraints.append(contentsOf: [

            self.collectionView.leadingAnchor.constraint(
                equalTo: view.readableContentGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(
                equalTo: view.readableContentGuide.trailingAnchor),

            self.collectionView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),

            self.collectionView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.5)
        ])

        constraints.append(contentsOf: [
            self.headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            self.headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.calendarHeaderHeight),

            self.footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            self.footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.footerView.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.calendarFooterHeight)
        ])

        NSLayoutConstraint.activate(constraints)

        self.collectionView.register(
            CalendarDateCollectionViewCell.self,
            forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
        )

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.headerView.baseDate = self.baseDate
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}

// MARK: - Day Generation

private extension CalendarPickerViewController {

    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard let numberOfDaysInMonth = calendar.range(of: .day,
                                                       in: .month,
                                                       for: baseDate)?.count,
              let firstDayOfMonth = self.calendar.date(from: calendar.dateComponents([.year, .month],
                                                                                from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        let firstDayWeekday = self.calendar.component(.weekday, from: firstDayOfMonth)
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }

    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: baseDate) else {
            assertionFailure("An error occurred when generating the metadata for \(baseDate)")
            return []
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset =
                isWithinDisplayedMonth ?
                day - offsetInInitialRow :
                -(offsetInInitialRow - day)

            return generateDay(offsetBy: dayOffset,
                               for: firstDayOfMonth,
                               isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        days += self.generateStartOfNextMonth(using: firstDayOfMonth)
        return days
    }

    func generateDay(offsetBy dayOffset: Int,
                     for baseDate: Date,
                     isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day,
                                 value: dayOffset,
                                 to: baseDate) ?? baseDate

        return Day(date: date,
                   number: dateFormatter.string(from: date),
                   isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                   isWithinDisplayedMonth: isWithinDisplayedMonth)
    }

    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {

        guard let lastDayInMonth = self.calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth) else {
            return []
        }

        let additionalDays = 7 - self.calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        let days: [Day] = (1...additionalDays).map {
            self.generateDay(offsetBy: $0,
                        for: lastDayInMonth,
                        isWithinDisplayedMonth: false)
        }
        return days
    }

    enum CalendarDataError: Error {
        case metadataGeneration
    }
}

// MARK: - UICollectionViewDataSource

extension CalendarPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        self.days.count
    }

    func collectionView( _ collectionView: UICollectionView,
                         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = self.days[indexPath.row]

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
            for: indexPath) as! CalendarDateCollectionViewCell
        cell.setupDay(day: day)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let day = self.days[indexPath.row]
        self.selectedDateChanged(day.date)
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / self.numberOfWeeksInBaseDate
        return CGSize(width: width, height: height)
    }
}
