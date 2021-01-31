//
//  ReminderInfoDateTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/31/21.
//

import UIKit

final class ReminderInfoDateTableViewCell: UITableViewCell {

    // MARK: - Properties

    static var reuseIdentifier: String {
        return String(describing: ReminderInfoDateTableViewCell.self)
    }
    var datePickerDidChangedValue: ((Date) -> Void)?

    // MARK: - Views

    private lazy var datePicker: UIDatePicker = {
        let myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self,
                               action: #selector(datePickerValueChanged),
                               for: .valueChanged)
        myDatePicker.preferredDatePickerStyle = .inline
        return myDatePicker
    }()

    @objc func datePickerValueChanged() {
        let date = self.datePicker.date
        self.datePickerDidChangedValue?(date)
    }

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

    func setupCell(cellType: DateAndTimeCellType) {
        if cellType == .time {
            // Время
            self.datePicker.datePickerMode = .time
        } else if cellType == .date {
            // Дата
            self.datePicker.datePickerMode = .date
        }
    }
}

// MARK: - UISetup

private extension ReminderInfoDateTableViewCell {
    func setupElements() {
        self.setupDatePicker()
    }

    func setupDatePicker() {
        self.contentView.addSubview(self.datePicker)
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.datePicker.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.datePicker.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.datePicker.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.datePicker.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
