//
//  PrioritiesListTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/4/21.
//

import UIKit

final class PrioritiesListTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: PrioritiesListTableViewCell.self)
    }

    // MARK: - Views

    private lazy var chosenCellImage: UIImageView = {
        let myImageView = UIImageView()
        myImageView.image = AppConstants.Images.checkmarkImage
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

    // MARK: - Private method

    func setupCell(cellPriority: Priority, chosenPriority: Priority) {
        self.textLabel?.text = cellPriority.rawValue
        if chosenPriority == cellPriority {
            self.chosenCellImage.isHidden = false
        } else {
            self.chosenCellImage.isHidden = true
        }
    }
}


// MARK: - UISetup

private extension PrioritiesListTableViewCell {
    func setupElements() {
        self.setupChosenCellImage()
    }

    func setupChosenCellImage() {
        self.contentView.addSubview(self.chosenCellImage)
        self.chosenCellImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.chosenCellImage.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.chosenCellImage.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.chosenCellImage.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.chosenCellImage.widthAnchor.constraint(
                equalTo: self.chosenCellImage.heightAnchor)
        ])
    }
}
