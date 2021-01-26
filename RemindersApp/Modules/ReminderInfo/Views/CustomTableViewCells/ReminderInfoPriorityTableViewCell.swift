//
//  ReminderInfoPriorityTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/26/21.
//

import UIKit

final class ReminderInfoPriorityTableViewCell: UITableViewCell {


    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoPriorityTableViewCell.self)
    }

    // MARK: - Views

    private let infoLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppConstants.AppFonts.reminderFont
        return myLabel
    }()

    private let infoPriorityLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppConstants.AppFonts.reminderFont
        myLabel.tintColor = .lightGray
        return myLabel
    }()

    private let arrowImage: UIImageView = {
        let myImageView = UIImageView()
        myImageView.image = AppConstants.Images.rightArrowImage
        myImageView.tintColor = .lightGray
        return myImageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    func setupCell(text: String, chosenPriority: Priority) {
        self.infoLabel.text = text
        self.infoPriorityLabel.text = chosenPriority.rawValue
    }
}

// MARK: - UISetup

private extension ReminderInfoPriorityTableViewCell {
    func setupElements() {
        self.setupArrowImage()
        self.setupInfoPriorityLabel()
        self.setupInfoLabel()
    }
    
    func setupArrowImage() {
        self.contentView.addSubview(self.arrowImage)
        self.arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.arrowImage.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.arrowImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.arrowImage.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.reminderInfoPriorityImageSize.height),
            self.arrowImage.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.reminderInfoPriorityImageSize.width)
        ])
    }
    
    func setupInfoPriorityLabel() {
        self.contentView.addSubview(self.infoPriorityLabel)
        self.infoPriorityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoPriorityLabel.trailingAnchor.constraint(
                equalTo: self.arrowImage.leadingAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint),
            self.infoPriorityLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    func setupInfoLabel() {
        self.contentView.addSubview(self.infoLabel)
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoLabel.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.normalConstraint),
            self.infoLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
