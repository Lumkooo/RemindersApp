//
//  ReminderInfoLocationTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/2/21.
//

import UIKit

final class ReminderInfoLocationTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoLocationTableViewCell.self)
    }

    var userCurrentLocationTapped: (() -> Void)?
    var getInCarTapped: (() -> Void)?
    var getOutCarTapped: (() -> Void)?

    // MARK: - Views

    private lazy var userCurrentLocationButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = .systemBlue
        myButton.setImage(AppConstants.Images.locationImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(userCurrentLocationButtonTapped),
                           for: .touchUpInside)
        myButton.layer.cornerRadius = AppConstants.Sizes.locationButtonSize.height / 2
        myButton.tintColor = .white
        return myButton
    }()

    private lazy var userCurrentLocationDescriptionButton: UIButton = {
        let myButton = UIButton()
        myButton.setTitle("Текущее", for: .normal)
        myButton.addTarget(self,
                           action: #selector(userCurrentLocationButtonTapped),
                           for: .touchUpInside)
        myButton.backgroundColor = .systemBlue
        myButton.layer.cornerRadius = AppConstants.Sizes.locationDescriptionButtonCornerRadius
        myButton.titleLabel?.font = AppConstants.AppFonts.reminderNotesFont
        return myButton
    }()

    private lazy var getInCarButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = .systemGray4
        myButton.addTarget(self,
                           action: #selector(getInCarButtonTapped),
                           for: .touchUpInside)
        myButton.setImage(AppConstants.Images.carImage, for: .normal)
        myButton.layer.cornerRadius = AppConstants.Sizes.locationButtonSize.height / 2
        myButton.tintColor = .white
        return myButton
    }()

    private lazy var getInCarDescriptionButton: UIButton = {
        let myButton = UIButton()
        myButton.setTitle("При посадке", for: .normal)
        myButton.backgroundColor = self.backgroundColor
        myButton.addTarget(self,
                           action: #selector(getInCarButtonTapped),
                           for: .touchUpInside)
        myButton.layer.cornerRadius = AppConstants.Sizes.locationDescriptionButtonCornerRadius
        myButton.setTitleColor(.black, for: .normal)
        myButton.titleLabel?.font = AppConstants.AppFonts.reminderNotesFont
        return myButton
    }()

    private lazy var getOutCarButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = .systemGray4
        myButton.addTarget(self,
                           action: #selector(getOutCarButtonTapped),
                           for: .touchUpInside)
        myButton.setImage(AppConstants.Images.carImage, for: .normal)
        myButton.layer.cornerRadius = AppConstants.Sizes.locationButtonSize.height / 2
        myButton.tintColor = .white
        return myButton
    }()

    private lazy var getOutCarDescriptionButton: UIButton = {
        let myButton = UIButton()
        myButton.setTitle("При выходе", for: .normal)
        myButton.addTarget(self,
                           action: #selector(getOutCarButtonTapped),
                           for: .touchUpInside)
        myButton.backgroundColor = self.backgroundColor
        myButton.layer.cornerRadius = AppConstants.Sizes.locationDescriptionButtonCornerRadius
        myButton.setTitleColor(.black, for: .normal)
        myButton.titleLabel?.font = AppConstants.AppFonts.reminderNotesFont
        return myButton
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupElements()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Обработка нажатий на кнопки

    @objc private func userCurrentLocationButtonTapped() {
        self.setupButtonsColor(button: self.userCurrentLocationButton,
                               decriptionButton: self.userCurrentLocationDescriptionButton)
        self.userCurrentLocationTapped?()
    }

    @objc private func getInCarButtonTapped() {
        self.setupButtonsColor(button: self.getInCarButton,
                               decriptionButton: self.getInCarDescriptionButton)
        self.getInCarTapped?()
    }

    @objc private func getOutCarButtonTapped() {
        self.setupButtonsColor(button: self.getOutCarButton,
                               decriptionButton: self.getOutCarDescriptionButton)
        self.getOutCarTapped?()
    }

    // MARK: - Public method

    func setupCell(chosenLocationType: ChosenLocationType) {
        switch chosenLocationType {
        case .userCurrent:
            self.setupButtonsColor(button: self.userCurrentLocationButton,
                                   decriptionButton: self.userCurrentLocationDescriptionButton)
        case .getInCar:
            self.setupButtonsColor(button: self.getInCarButton,
                                   decriptionButton: self.getInCarDescriptionButton)
        case .getOutCar:
            self.setupButtonsColor(button: self.getOutCarButton,
                                   decriptionButton: self.getOutCarDescriptionButton)
        }
    }
}

// MARK: - Настройка отображения UI при нажатии на кнопку

private extension ReminderInfoLocationTableViewCell {
    func setupButtonAsTapped(button: UIButton) {
        button.backgroundColor = .systemBlue
    }

    func setupButtonAsUntapped(button: UIButton) {
        button.backgroundColor = .systemGray4
    }

    func setupDescriptionButtonAsTapped(button: UIButton) {
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
    }

    func setupDescriptionButtonAsUntapped(button: UIButton) {
        button.backgroundColor = self.backgroundColor
        button.setTitleColor(.label, for: .normal)
    }

    func setupButtonsColor(button: UIButton, decriptionButton: UIButton) {
        self.setupButtonAsUntapped(button: self.userCurrentLocationButton)
        self.setupButtonAsUntapped(button: self.getInCarButton)
        self.setupButtonAsUntapped(button: self.getOutCarButton)

        self.setupDescriptionButtonAsUntapped(button: self.userCurrentLocationDescriptionButton)
        self.setupDescriptionButtonAsUntapped(button: self.getInCarDescriptionButton)
        self.setupDescriptionButtonAsUntapped(button: self.getOutCarDescriptionButton)

        self.setupButtonAsTapped(button: button)
        self.setupDescriptionButtonAsTapped(button: decriptionButton)
    }

    func setupdescriptionButton(button: UIButton) {

    }
}

// MARK: UISetup

private extension ReminderInfoLocationTableViewCell {
    func setupElements() {
        self.setupUserCurrentLocationButton()
        self.setupUserCurrentLocationDescriptionButton()
        self.setupGetInCarButton()
        self.setupGetInCarDescriptionButton()
        self.setupGetOutCarButton()
        self.setupGetOutCarDescriptionButton()
    }

    func setupUserCurrentLocationButton() {
        self.contentView.addSubview(self.userCurrentLocationButton)
        self.userCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.userCurrentLocationButton.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.normalConstraint),
            self.userCurrentLocationButton.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.normalConstraint),
            self.userCurrentLocationButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.locationButtonSize.height),
            self.userCurrentLocationButton.widthAnchor.constraint(
                equalTo: self.userCurrentLocationButton.heightAnchor)
        ])
    }

    func setupUserCurrentLocationDescriptionButton() {
        self.contentView.addSubview(self.userCurrentLocationDescriptionButton)
        self.userCurrentLocationDescriptionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.userCurrentLocationDescriptionButton.centerXAnchor.constraint(
                equalTo: self.userCurrentLocationButton.centerXAnchor),
            self.userCurrentLocationDescriptionButton.topAnchor.constraint(
                equalTo: self.userCurrentLocationButton.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.userCurrentLocationDescriptionButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.userCurrentLocationDescriptionButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.locationDescriptionButtonHeight)
        ])
    }

    func setupGetInCarButton() {
        self.contentView.addSubview(self.getInCarButton)
        self.getInCarButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.getInCarButton.centerXAnchor.constraint(
                equalTo: self.contentView.centerXAnchor),
            self.getInCarButton.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.normalConstraint),
            self.getInCarButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.locationButtonSize.height),
            self.getInCarButton.widthAnchor.constraint(
                equalTo: self.getInCarButton.heightAnchor)
        ])
    }

    func setupGetInCarDescriptionButton() {
        self.contentView.addSubview(self.getInCarDescriptionButton)
        self.getInCarDescriptionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.getInCarDescriptionButton.centerXAnchor.constraint(
                equalTo: self.getInCarButton.centerXAnchor),
            self.getInCarDescriptionButton.topAnchor.constraint(
                equalTo: self.getInCarButton.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.getInCarDescriptionButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.getInCarDescriptionButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.locationDescriptionButtonHeight)
        ])
    }

    func setupGetOutCarButton() {
        self.contentView.addSubview(self.getOutCarButton)
        self.getOutCarButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.getOutCarButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.normalConstraint),
            self.getOutCarButton.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.normalConstraint),
            self.getOutCarButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.locationButtonSize.height),
            self.getOutCarButton.widthAnchor.constraint(
                equalTo: self.getOutCarButton.heightAnchor)
        ])
    }

    func setupGetOutCarDescriptionButton() {
        self.contentView.addSubview(self.getOutCarDescriptionButton)
        self.getOutCarDescriptionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.getOutCarDescriptionButton.centerXAnchor.constraint(
                equalTo: self.getOutCarButton.centerXAnchor),
            self.getOutCarDescriptionButton.topAnchor.constraint(
                equalTo: self.getOutCarButton.bottomAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.getOutCarDescriptionButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.getOutCarDescriptionButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.locationDescriptionButtonHeight)
        ])
    }
}
