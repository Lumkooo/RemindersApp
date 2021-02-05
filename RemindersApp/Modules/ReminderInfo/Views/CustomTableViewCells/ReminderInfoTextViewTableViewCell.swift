//
//  ReminderInfoTextFieldTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/25/21.
//

import UIKit

 class ReminderInfoTextViewTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoTextViewTableViewCell.self)
    }
    private weak var parentTableView: UITableView?
    private var placeholderText: String = ""
    var textViewDidChange: ((String) -> Void)?

    // MARK: - Views

    private let textView: UITextView = {
        let myTextView = UITextView()
        myTextView.font = AppConstants.AppFonts.reminderFont
        myTextView.isScrollEnabled = false
        return myTextView
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

    // MARK: - Public Method

    func setupCell(tableView: UITableView,
                   placeholder: String,
                   text: String) {
        if text.isEmpty {
        self.textView.text = placeholder
        self.textView.textColor = UIColor.lightGray
        self.textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                             to: textView.beginningOfDocument)
        } else {
            self.textView.text = text
            self.textView.textColor = .black
        }
        self.placeholderText = placeholder
        self.parentTableView = tableView
    }
}

// MARK: - UISetup

private extension ReminderInfoTextViewTableViewCell {
    func setupElements() {
        self.setupTextView()
    }

    func setupTextView() {
        self.contentView.addSubview(self.textView)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.delegate = self
        self.textView.backgroundColor = self.backgroundColor

        NSLayoutConstraint.activate([
            self.textView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.quarterNormalConstraint),
            self.textView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.textView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.textView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint)
        ])
    }
}

// MARK: - UITextViewDelegate

extension ReminderInfoTextViewTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.parentTableView?.beginUpdates()
        self.parentTableView?.endUpdates()
        guard let text = textView.text else {
            return
        }
        self.textViewDidChange?(text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
