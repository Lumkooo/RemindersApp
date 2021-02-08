//
//  ReminderInfoImageTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/5/21.
//

import UIKit

final class ReminderInfoImageTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoImageTableViewCell.self)
    }
    var deleteButtonTapped: (() -> Void)?

    // MARK: - Views

    private lazy var photoImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.layer.cornerRadius = AppConstants.Sizes.reminderInfoIconCornerRadius
        return myImageView
    }()

    private lazy var photoNameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppConstants.AppFonts.reminderFont
        return myLabel
    }()

    private lazy var deletingButton: UIButton = {
        let myButton = UIButton()
        myButton.tintColor = .red
        myButton.setImage(AppConstants.Images.minusCircleFill,
                          for: .normal)
        myButton.addTarget(self, action: #selector(deletingAction), for: .touchUpInside)
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

    // MARK: - Public method

    func setupCell(image: UIImage) {
        self.photoImageView.image = image
        self.photoNameLabel.text = "Изображение"
    }

    // MARK: - Обработка нажатия на кнопки

    @objc func deletingAction() {
        self.deleteButtonTapped?()
    }
}

// MARK: - UISetup

private extension ReminderInfoImageTableViewCell {
    func setupElements() {
        self.setupPhotoImageView()
        self.setupDeletingButton()
        self.setupPhotoNameLabel()
    }

    func setupPhotoImageView() {
        self.contentView.addSubview(self.photoImageView)
        self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.photoImageView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            self.photoImageView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.photoImageView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.photoImageView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.photoImageView.heightAnchor.constraint(equalToConstant: AppConstants.Sizes.reminderInfoImageSize.height),
            self.photoImageView.widthAnchor.constraint(equalToConstant: AppConstants.Sizes.reminderInfoImageSize.width)
        ])
    }

    func setupDeletingButton() {
        self.contentView.addSubview(self.deletingButton)
        self.deletingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.deletingButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.normalConstraint),
            self.deletingButton.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor),
            self.deletingButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.reminderInfoDeletingButtonSize.height),
            self.deletingButton.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.reminderInfoDeletingButtonSize.width)
        ])
    }

    func setupPhotoNameLabel() {
        self.contentView.addSubview(self.photoNameLabel)
        self.photoNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.photoNameLabel.leadingAnchor.constraint(
                equalTo: self.photoImageView.trailingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.photoNameLabel.trailingAnchor.constraint(
                equalTo: self.deletingButton.leadingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.photoNameLabel.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor)
        ])
    }
}
