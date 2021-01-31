//
//  ReminderInfoTableViewDataSource.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/25/21.
//

import UIKit

protocol IReminderInfoTableViewDataSource {
    func textViewDidChange(indexPath: IndexPath, text: String)
    func switchValueDidChange(indexPath: IndexPath, value: Bool)
    func dateChanged(newDate: Date)
    func timeChanged(newTime: Date)
}

final class ReminderInfoTableViewDataSource: NSObject {

    // MARK: - Properties

    private let delegate: IReminderInfoTableViewDataSource
    var reminderInfo = ReminderInfo()
    var reminder = Reminder()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()

    // MARK: - Init

    init(delegate: IReminderInfoTableViewDataSource) {
        self.delegate = delegate
    }

    // MARK: - Public methods

    func showCalendar() {
        self.reminderInfo.dateAndTimeInfo.calendarIsShowing = true
    }

    func hideCalendar() {
        self.reminderInfo.dateAndTimeInfo.calendarIsShowing = false
    }

    func showTime() {
        self.reminderInfo.dateAndTimeInfo.timeIsShowing = true
    }

    func hideTime() {
        self.reminderInfo.dateAndTimeInfo.timeIsShowing = false
    }

}

// MARK: - UITableViewDataSource

extension ReminderInfoTableViewDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.reminderInfo.mainInfo.count
        case 1:
            return self.reminderInfo.dateAndTimeInfo.stringRepresentation.count
        case 2:
            return self.reminderInfo.locationInfo.stringRepresentation.count
        case 3:
            return self.reminderInfo.messagingInfo.stringRepresentation.count
        case 4:
            return self.reminderInfo.flagInfo.stringRepresentation.count
        case 5:
            return self.reminderInfo.priorityInfo.count
        case 6:
            return self.reminderInfo.addImageInfo.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 3 {
            return "Selecting this option will show the reminder notification when chatting with a person in Meesages"
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = indexPath.section
        if section == 0 {

            // MARK: - ReminderInfoTextViewTableViewCell(TextView)

            guard let firstCell = tableView.dequeueReusableCell(
                    withIdentifier: ReminderInfoTextViewTableViewCell.reuseIdentifier, for: indexPath)
                    as? ReminderInfoTextViewTableViewCell else {
                assertionFailure("oops, error")
                return UITableViewCell()
            }

            let placeholder = self.reminderInfo.mainInfo[indexPath.row]
            var text: String = ""
            if indexPath.row == 0 {
                text = self.reminder.text
            } else if indexPath.row == 1 {
                text = self.reminder.note ?? ""
            } else if indexPath.row == 2 {
                text = self.reminder.url ?? ""
            }
            firstCell.setupCell(tableView: tableView,
                                indexPath: indexPath,
                                placeholder: placeholder,
                                text: text)
            firstCell.textViewDidChange = { [weak self] (indexPath, text) in
                self?.delegate.textViewDidChange(indexPath: indexPath, text: text)
            }
            return firstCell
        } else if section > 0 && section < 5 {

            // MARK: - ReminderInfoSwitcherTableViewCell(Switch)

            guard let secondCell = tableView.dequeueReusableCell(
                    withIdentifier: ReminderInfoSwitcherTableViewCell.reuseIdentifier, for: indexPath)
                    as? ReminderInfoSwitcherTableViewCell else {
                assertionFailure("oops, error")
                return UITableViewCell()
            }

            var text: String = ""
            var image: UIImage = UIImage()
            var imageBackgroundColor: UIColor = .white
            var isSwitchActive: Bool = false

            if section == 1 {
                if indexPath.row == 0 || indexPath.row == 1 {
                    let dateAndTimeInfo = self.reminderInfo.dateAndTimeInfo
                    text = dateAndTimeInfo.stringRepresentation[indexPath.row]
                    image = dateAndTimeInfo.image[indexPath.row]
                    imageBackgroundColor = dateAndTimeInfo.imageColors[indexPath.row]
                    if indexPath.row == 0 {
                        isSwitchActive = dateAndTimeInfo.calendarIsShowing
                    } else if indexPath.row == 1 {
                        isSwitchActive = dateAndTimeInfo.timeIsShowing
                    }
                } else if indexPath.row == 2 {

                    // MARK: - Ячейка с календарем

                    guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: ReminderInfoDateTableViewCell.reuseIdentifier,
                            for: indexPath) as? ReminderInfoDateTableViewCell else {
                        assertionFailure("oops, something went wrong")
                        return UITableViewCell()
                    }
                    cell.setupCell(cellType: .date)
                    cell.datePickerDidChangedValue = { [weak self] (date) in
                        self?.delegate.dateChanged(newDate: date)
                    }
                    return cell
                } else if indexPath.row == 3 {

                    // MARK: - Ячейка с часами

                    guard let cell = tableView.dequeueReusableCell(
                            withIdentifier: ReminderInfoDateTableViewCell.reuseIdentifier,
                            for: indexPath) as? ReminderInfoDateTableViewCell else {
                        assertionFailure("oops, something went wrong")
                        return UITableViewCell()
                    }

                    cell.setupCell(cellType: .time)
                    cell.datePickerDidChangedValue = { [weak self] (date) in
                        self?.delegate.timeChanged(newTime: date)
                    }
                    return cell
                }
            } else if section == 2 {
                let locationInfo = self.reminderInfo.locationInfo
                text = locationInfo.stringRepresentation[indexPath.row]
                image = locationInfo.image
                imageBackgroundColor = locationInfo.imageColor
            } else if section == 3 {
                let messagingInfo = self.reminderInfo.messagingInfo
                text = messagingInfo.stringRepresentation[indexPath.row]
                image = messagingInfo.image
                imageBackgroundColor = messagingInfo.imageColor
            } else if section == 4 {
                let flagInfo = self.reminderInfo.flagInfo
                text = flagInfo.stringRepresentation[indexPath.row]
                image = flagInfo.image
                imageBackgroundColor = flagInfo.imageColor
            }
            
            secondCell.setupCell(tableView: tableView,
                                 indexPath: indexPath,
                                 text: text,
                                 image: image,
                                 imageBackgroundColor: imageBackgroundColor,
                                 isSwitchActive: isSwitchActive)
            secondCell.switchValueDidChange = { [weak self] (indexPath, value) in
                self?.delegate.switchValueDidChange(indexPath: indexPath, value: value)
            }
            return secondCell
        } else if section == 5 {

            // MARK: - ReminderInfoPriorityTableViewCell(Приоритет)

            guard let thirdCell = tableView.dequeueReusableCell(
                    withIdentifier: ReminderInfoPriorityTableViewCell.reuseIdentifier, for: indexPath)
                    as? ReminderInfoPriorityTableViewCell else {
                assertionFailure("oops, error")
                return UITableViewCell()
            }
            let text = self.reminderInfo.priorityInfo[indexPath.row]
            let priority = Priority()
            thirdCell.setupCell(text: text,
                                chosenPriority: priority)
            return thirdCell
        } else {

            // MARK: - Добавление картинки

            let cell = tableView.dequeueReusableCell(
                withIdentifier: AppConstants.TableViewCells.cellID, for: indexPath)
            cell.textLabel?.textColor = .systemBlue
            let text = self.reminderInfo.addImageInfo[indexPath.row]
            cell.textLabel?.text = text
            return cell
        }
    }
}
