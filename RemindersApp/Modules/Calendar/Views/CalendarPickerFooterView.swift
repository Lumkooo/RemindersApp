//
//  CalendarPickerFooterView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/27/21.
//

import UIKit

class CalendarPickerFooterView: UIView {

    // MARK: - Views

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(AppConstants.Sizes.separatorViewAlpha)
        return view
    }()

    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = AppConstants.AppFonts.calendarButtonsFont
        button.titleLabel?.textAlignment = .left

        if let chevronImage = AppConstants.Images.chevronLeftImage  {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString()
            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )

            attributedString.append(
                NSAttributedString(string: " Предыдущий")
            )

            button.setAttributedTitle(attributedString, for: .normal)
        } else {
            button.setTitle("Предыдущий", for: .normal)
        }
        button.titleLabel?.textColor = .label
        button.addTarget(self,
                         action: #selector(didTapPreviousMonthButton),
                         for: .touchUpInside)
        return button
    }()

    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = AppConstants.AppFonts.calendarButtonsFont
        button.titleLabel?.textAlignment = .right
        if let chevronImage = AppConstants.Images.chevronRightImage {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString(string: "Следующий")

            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )

            button.setAttributedTitle(attributedString, for: .normal)
        } else {
            button.setTitle("Следующий", for: .normal)
        }
        button.titleLabel?.textColor = .label
        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    private let didTapLastMonthCompletionHandler: (() -> Void)
    private let didTapNextMonthCompletionHandler: (() -> Void)
    private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation

    // MARK: - Init

    init(didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void)) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler

        super.init(frame: CGRect.zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGroupedBackground
        self.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = AppConstants.Sizes.calendarCornerRadius
        self.addSubview(self.separatorView)
        self.addSubview(self.previousMonthButton)
        self.addSubview(self.nextMonthButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()

        let smallDevice = UIScreen.main.bounds.width <= 350
        let fontPointSize: CGFloat = smallDevice ? 14 : 17
        self.previousMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
        self.nextMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)

        NSLayoutConstraint.activate([
            self.separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.separatorView.topAnchor.constraint(equalTo: topAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1),
            self.previousMonthButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.nextMonthButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Обработка нажатий на кнопки
    
    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }

    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
}
