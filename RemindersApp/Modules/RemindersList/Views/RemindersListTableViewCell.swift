//
//  RemindersListTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

final class RemindersListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: RemindersListTableViewCell.self)
    }
    private weak var parentTableView: UITableView?
    private var cellIndex: Int = 0
    var isDoneButtonTapped: (() -> Void)?
    var infoButtonTapped: (() -> Void)?
    var textViewDidChange: ((Int, String) -> Void)?

    // MARK: - Views

    private let reminderTextView: UITextView = {
        let myTextView = UITextView()
        myTextView.font = AppConstants.AppFonts.reminderFont
        myTextView.isScrollEnabled = false
        return myTextView
    }()

    private lazy var isDoneButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.circleImage, for: .normal)
        myButton.tintColor = .systemGray
        myButton.addTarget(self,
                           action: #selector(isDoneButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myButton
    }()

    private lazy var infoButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.infoImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(infoButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myButton
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

    func setupCell(tableView: UITableView, cellIndex: Int, text: String) {
        self.reminderTextView.text = text
        self.parentTableView = tableView
        self.cellIndex = cellIndex
    }

    // MARK: - Buttons action methods

    @objc private func infoButtonTapped(gesture: UIGestureRecognizer) {
        self.infoButtonTapped?()
    }

    @objc private func isDoneButtonTapped(gesture: UIGestureRecognizer) {
        self.isDoneButtonTapped?()
    }

}

// MARK: - UISetup

private extension RemindersListTableViewCell {
    func setupElements() {
        self.setupIsDoneButton()
        self.setupInfoButton()
        self.setupReminderTextView()
    }

    func setupIsDoneButton() {
        self.contentView.addSubview(self.isDoneButton)
        self.isDoneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.isDoneButton.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor),
            self.isDoneButton.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.isDoneButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.isDoneButtonSize.height),
            self.isDoneButton.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.isDoneButtonSize.width)
        ])
    }

    func setupInfoButton() {
        self.contentView.addSubview(self.infoButton)
        self.infoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.infoButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.infoButton.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor),
            self.infoButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.infoButtonSize.height),
            self.infoButton.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.infoButtonSize.width)
        ])
    }

    func setupReminderTextView() {
        self.contentView.addSubview(self.reminderTextView)
        self.reminderTextView.translatesAutoresizingMaskIntoConstraints = false
        self.reminderTextView.delegate = self

        NSLayoutConstraint.activate([
            self.reminderTextView.leadingAnchor.constraint(
                equalTo: self.isDoneButton.trailingAnchor,
                constant: AppConstants.Constraints.quarterNormalConstraint),
            self.reminderTextView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.reminderTextView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.reminderTextView.trailingAnchor.constraint(
                equalTo: self.infoButton.leadingAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint)
        ])
    }
}

extension RemindersListTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.parentTableView?.beginUpdates()
        self.parentTableView?.endUpdates()
        guard let text = textView.text else {
            return
        }
        self.textViewDidChange?(self.cellIndex,
                                text)
//        ReminderManager.shared.updateElement(atIndex: self.cellIndex,
//                                             text: text)
    }

    func setSelected(selected: Bool, animated: Bool) {
        self.reminderTextView.becomeFirstResponder()
    }
}
