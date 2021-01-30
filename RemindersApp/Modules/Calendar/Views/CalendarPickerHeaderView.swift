//
//  CalendarPickerHeaderView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/27/21.
//

import UIKit

class CalendarPickerHeaderView: UIView {

    // MARK: - Views

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Месяц"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = AppConstants.Images.xmarCircleFillImage
        image?.withConfiguration(configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .secondaryLabel
        button.contentMode = .scaleAspectFill
        button.isUserInteractionEnabled = true
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Close Picker"
        return button
    }()

    private lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(AppConstants.Sizes.separatorViewAlpha)
        return view
    }()

    // MARK: - Properties

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()

    var baseDate = Date() {
        didSet {
            self.monthLabel.text = self.dateFormatter.string(from: self.baseDate)
        }
    }

    private var exitButtonTappedCompletionHandler: (() -> Void)

    // MARK: - Init

    init(exitButtonTappedCompletionHandler: @escaping (() -> Void)) {
        self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler

        super.init(frame: CGRect.zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGroupedBackground
        self.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = AppConstants.Sizes.calendarCornerRadius
        self.addSubview(monthLabel)
        self.addSubview(closeButton)
        self.addSubview(dayOfWeekStackView)
        self.addSubview(separatorView)

        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = AppConstants.AppFonts.calendarDaysFont
            dayLabel.textColor = .secondaryLabel
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)

            // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
            // If fact, they get in the way!
            // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
            // That method provides the same amount of context as this stack view does to visual users
            dayLabel.isAccessibilityElement = false
            self.dayOfWeekStackView.addArrangedSubview(dayLabel)
        }

        self.closeButton.addTarget(self,
                                   action: #selector(didTapExitButton),
                                   for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Обработка нажатий на кнопку

    @objc func didTapExitButton() {
        self.exitButtonTappedCompletionHandler()
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            self.monthLabel.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: AppConstants.Constraints.normalConstraint),
            self.monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: AppConstants.Constraints.normalConstraint),
            self.monthLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor,
                                                      constant: AppConstants.Constraints.quarterNormalConstraint),

            self.closeButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            self.closeButton.heightAnchor.constraint(equalToConstant: AppConstants.Constraints.doubleConstraint),
            self.closeButton.widthAnchor.constraint(equalToConstant: AppConstants.Constraints.doubleConstraint),
            self.closeButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -AppConstants.Constraints.normalConstraint),

            self.dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.dayOfWeekStackView.bottomAnchor.constraint(
                equalTo: separatorView.bottomAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint),

            self.separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - private methods

    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "Вс"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
        default:
            return ""
        }
    }
}
