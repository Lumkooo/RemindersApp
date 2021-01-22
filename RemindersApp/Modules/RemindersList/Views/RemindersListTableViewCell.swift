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

    // MARK: - Views

    private let reminderTextView: UITextView = {
        let myTextView = UITextView()
        myTextView.font = AppConstants.AppFonts.reminderFont
        myTextView.isScrollEnabled = false
        return myTextView
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
}

// MARK: - UISetup

private extension RemindersListTableViewCell {
    func setupElements() {
        self.setupReminderTextView()
    }

    func setupReminderTextView() {
        self.contentView.addSubview(self.reminderTextView)
        self.reminderTextView.translatesAutoresizingMaskIntoConstraints = false
        self.reminderTextView.delegate = self

        NSLayoutConstraint.activate([
            self.reminderTextView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.normalConstraint),
            self.reminderTextView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.reminderTextView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.reminderTextView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.normalConstraint)
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
        ReminderManager.shared.updateElement(atIndex: self.cellIndex,
                                             text: text)
    }

    func setSelected(selected: Bool, animated: Bool) {
        self.reminderTextView.becomeFirstResponder()
    }
}
