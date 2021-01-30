//
//  CalendarDateCollectionViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/27/21.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {

    // MARK: - Views

    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .systemRed
        return view
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = AppConstants.AppFonts.calendarDaysFont
        label.textColor = .label
        return label
    }()

    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()

    // MARK: - Properties

    static let reuseIdentifier = String(describing: CalendarDateCollectionViewCell.self)

    private var day: Day? {
        didSet {
            guard let day = self.day else { return }
            self.numberLabel.text = day.number
            self.accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
            self.updateSelectionStatus()
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isAccessibilityElement = true
        self.accessibilityTraits = .button
        self.contentView.addSubview(self.selectionBackgroundView)
        self.contentView.addSubview(self.numberLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        // This allows for rotations and trait collection
        // changes (e.g. entering split view on iPad) to update constraints correctly.
        // Removing old constraints allows for new ones to be created
        // regardless of the values of the old ones
        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)

        let size = traitCollection.horizontalSizeClass == .compact ?
            min(min(frame.width, frame.height) - 10, 60) : 45

        NSLayoutConstraint.activate([
            self.numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.selectionBackgroundView.centerYAnchor.constraint(equalTo: self.numberLabel.centerYAnchor),
            self.selectionBackgroundView.centerXAnchor.constraint(equalTo: self.numberLabel.centerXAnchor),
            self.selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            self.selectionBackgroundView.heightAnchor.constraint(equalTo: self.selectionBackgroundView.widthAnchor)
        ])
        self.selectionBackgroundView.layer.cornerRadius = size / 2
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layoutSubviews()
    }

    // MARK: - Public method

    func setupDay(day: Day?) {
        self.day = day
    }
}

// MARK: - Appearance

private extension CalendarDateCollectionViewCell {

    func updateSelectionStatus() {
        guard let day = day else { return }
        if day.isSelected {
            self.applySelectedStyle()
        } else {
            self.applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
        }
    }
    
    var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth = UIScreen.main.bounds.width <= 350
        let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        return isCompact && (smallWidth || widthGreaterThanHeight)
    }
    
    func applySelectedStyle() {
        self.accessibilityTraits.insert(.selected)
        self.accessibilityHint = nil
        self.numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
        self.selectionBackgroundView.isHidden = isSmallScreenSize
    }
    
    func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
        self.accessibilityTraits.remove(.selected)
        self.accessibilityHint = "Tap to select"
        self.numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
        self.selectionBackgroundView.isHidden = true
    }
}
