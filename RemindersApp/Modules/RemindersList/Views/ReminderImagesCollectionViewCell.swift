//
//  ReminderImagesCollectionViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/7/21.
//

import UIKit

final class ReminderImagesCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderImagesCollectionViewCell.self)
    }

    // MARK: - Views

    private lazy var reminderImageView: UIImageView = {
        let myImageView = UIImageView()
        return myImageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    func setupCell(image: UIImage) {
        self.reminderImageView.image = image
    }
}

// MARK: - UISetup

private extension ReminderImagesCollectionViewCell {
    func setupElements() {
        self.setupReminderImageView()
        self.setupCellLayer()
    }

    func setupReminderImageView() {
        self.contentView.addSubview(self.reminderImageView)
        self.reminderImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.reminderImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.reminderImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.reminderImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.reminderImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setupCellLayer() {
        self.contentView.layer.cornerRadius = AppConstants.Sizes.reminderImageCornerRadius
        self.contentView.layer.masksToBounds = true
    }
}
