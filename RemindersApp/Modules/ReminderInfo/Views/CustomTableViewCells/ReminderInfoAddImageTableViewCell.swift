//
//  ReminderInfoAddImageTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/5/21.
//

import UIKit

final class ReminderInfoAddImageTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoAddImageTableViewCell.self)
    }
    var photoLibraryMenuItemTapped: (() -> Void)?
    var takePhotoMenuItemTapped: (() -> Void)?

    // MARK: - Views

    private lazy var addImageButton: UIButton = {
        let myButton = UIButton()
        myButton.setTitle("Добавить изображение", for: .normal)
        myButton.setTitleColor(.systemBlue, for: .normal)
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
}


private extension ReminderInfoAddImageTableViewCell {
    func setupElements() {
        self.setupAddImageButton()
    }

    func setupAddImageButton() {
        self.contentView.addSubview(self.addImageButton)
        self.addImageButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.addImageButton.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            self.addImageButton.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint),
            self.addImageButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            self.addImageButton.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.quarterNormalConstraint)
        ])

        let items = UIMenu(title: "More", options: .displayInline, children: [
            UIAction(title: "Photo Library",
                     image: AppConstants.Images.photoImage,
                     handler: { _ in
                        self.photoLibraryMenuItemTapped?()
                     }),
            UIAction(title: "Take Photo",
                     image: AppConstants.Images.cameraImage,
                     handler: { _ in
                        self.takePhotoMenuItemTapped?()
                     })
        ])

        self.addImageButton.menu = UIMenu(title: "", children: [items])
        self.addImageButton.showsMenuAsPrimaryAction = true
        self.addImageButton.addAction(UIAction(title: ""){ _ in  },for: .menuActionTriggered)

    }
}
