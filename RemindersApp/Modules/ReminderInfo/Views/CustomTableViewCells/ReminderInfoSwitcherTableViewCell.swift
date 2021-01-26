//
//  ReminderInfoSwitcherTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/25/21.
//

import UIKit

final class ReminderInfoSwitcherTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoSwitcherTableViewCell.self)
    }
    private weak var parentTableView: UITableView?
    private var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var switchValueDidChange: ((IndexPath, Bool) -> Void)?

    // MARK: - Views

    private let iconImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.tintColor = .white
        myImageView.layer.cornerRadius = AppConstants.Sizes.reminderInfoIconCornerRadius
        myImageView.contentMode = .center
        return myImageView
    }()

    private let infoTextLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.font = AppConstants.AppFonts.reminderFont
        myLabel.textAlignment  = .natural
        return myLabel
    }()

    private lazy var switcher: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.addTarget(self,
                           action: #selector(switchChanged(mySwitch:)),
                           for: UIControl.Event.valueChanged)
        return mySwitch
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

    // MARK: - Publich method

    func setupCell(tableView: UITableView,
                   indexPath: IndexPath,
                   text: String,
                   image: UIImage,
                   imageBackgroundColor: UIColor,
                   isSwitchActive: Bool) {
        self.parentTableView = tableView
        self.indexPath = indexPath
        self.iconImageView.image = image
        self.iconImageView.backgroundColor = imageBackgroundColor
        self.infoTextLabel.text = text
    }

    // MARK: - Action для Switch-а

    @objc private func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        self.switchValueDidChange?(self.indexPath, value)
    }
}

private extension ReminderInfoSwitcherTableViewCell {
    func setupElements() {
        self.setupSwitcher()
        self.setupIconImageView()
        self.setupInfoTextLabel()
    }

    func setupSwitcher() {
        self.contentView.addSubview(self.switcher)
        self.switcher.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.switcher.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                    constant: -AppConstants.Constraints.normalConstraint),
            self.switcher.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                    constant: AppConstants.Constraints.halfNormalConstraint),
            self.switcher.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                    constant: -AppConstants.Constraints.halfNormalConstraint),
        ])
    }


    func setupIconImageView() {
        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.iconImageView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.iconImageView.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor),
            self.iconImageView.widthAnchor.constraint(
                equalTo: self.switcher.heightAnchor,
                multiplier: 0.9),
            self.iconImageView.heightAnchor.constraint(
                equalTo: self.switcher.heightAnchor,
                multiplier: 0.9)
        ])
    }

    func setupInfoTextLabel() {
        self.contentView.addSubview(self.infoTextLabel)
        self.infoTextLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.infoTextLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor,
                                                        constant: AppConstants.Constraints.normalConstraint),
            self.infoTextLabel.trailingAnchor.constraint(equalTo: self.switcher.leadingAnchor,
                                                        constant: -AppConstants.Constraints.normalConstraint),
            self.infoTextLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

}
