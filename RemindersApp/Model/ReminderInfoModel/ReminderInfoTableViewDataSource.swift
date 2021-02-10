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
    func userCurrentLocationChosen()
    func getInCarLocationChosen()
    func getOutCarLocationChosen()
    func takePhotoTapped()
    func photoLibraryTapped()
    func deleteImageButtonTapped(atIndex index: Int)
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

    func showLocation() {
        self.reminderInfo.locationInfo.locationIsShowing = true
    }

    func hideLocation() {
        self.reminderInfo.locationInfo.locationIsShowing = false
    }

    func setupViewForUsersCurrentLocation(stringLocation: String) {
        self.reminderInfo.locationInfo.chosenLocationType = .userCurrent
        self.reminderInfo.locationInfo.chosenLocation = stringLocation
    }

    func setupViewForGetInCarLocation() {
        self.reminderInfo.locationInfo.chosenLocationType = .getInCar
    }

    func setupViewForGetOutCarLocation() {
        self.reminderInfo.locationInfo.chosenLocationType = .getOutCar
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
            return self.reminderInfo.addImageInfo.count + self.reminder.photos.count
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
            // Ячейка с textView
            return self.setupTextViewTableViewCell(tableView: tableView,
                                            indexPath: indexPath)
        } else if section > 0 && section < 5 {
            // Ячейки с switch
            return self.setupCellWithSwitch(tableView: tableView,
                                            indexPath: indexPath)
        } else if section == 5 {
            // Ячейка для выбора приоритета
            return self.setupPriorityTableViewCell(tableView: tableView,
                                                   indexPath: indexPath)
        } else {
            // Ячейки для добавления и отображения картинки
            return self.setupAddImageTableViewCell(tableView: tableView,
                                                   indexPath: indexPath)
        }
    }
}

// MARK: - Методы для работы с ячейками tableView

private extension ReminderInfoTableViewDataSource {

    // MARK: - Настройка ячейки TableView с textView

    private func setupTextViewTableViewCell(tableView: UITableView,
                                            indexPath: IndexPath) -> UITableViewCell {

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
        firstCell.setupCell(placeholder: placeholder,
                            text: text)
        firstCell.textViewDidChange = { [weak self] (text) in
            tableView.beginUpdates()
            tableView.endUpdates()
            self?.delegate.textViewDidChange(indexPath: indexPath, text: text)
        }
        return firstCell
    }

    // MARK: - Настройка ячейки TableView для выбора приоритета

    func setupPriorityTableViewCell(tableView: UITableView,
                                    indexPath: IndexPath) -> UITableViewCell {
        guard let thirdCell = tableView.dequeueReusableCell(
                withIdentifier: ReminderInfoPriorityTableViewCell.reuseIdentifier, for: indexPath)
                as? ReminderInfoPriorityTableViewCell else {
            assertionFailure("oops, error")
            return UITableViewCell()
        }
        let text = self.reminderInfo.priorityInfo[indexPath.row]
        let priority = self.reminder.priority ?? .none
        thirdCell.setupCell(text: text,
                            chosenPriority: priority)
        return thirdCell
    }

    func setupAddImageTableViewCell(tableView: UITableView,
                        indexPath: IndexPath) -> UITableViewCell {

        // MARK: - Настройка ячейки TableView для добавления картинки

        if indexPath.row == 0 {
            guard let addNewImageCell = tableView.dequeueReusableCell(
                    withIdentifier: ReminderInfoAddImageTableViewCell.reuseIdentifier, for: indexPath)
                    as? ReminderInfoAddImageTableViewCell else {
                assertionFailure("oops, error")
                return UITableViewCell()
            }

            addNewImageCell.photoLibraryMenuItemTapped = { [weak self] in
                self?.delegate.photoLibraryTapped()
            }

            addNewImageCell.takePhotoMenuItemTapped = { [weak self] in
                self?.delegate.takePhotoTapped()
            }

            return addNewImageCell
        } else {

            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ReminderInfoImageTableViewCell.reuseIdentifier, for: indexPath)
                    as? ReminderInfoImageTableViewCell else {
                assertionFailure("oops, error")
                return UITableViewCell()
            }
            // Берем изображение с индекса - indexPath.row - 1 потому что первая ячейка - ячейка с
            // кнопкой для добавления изображений
            guard let image = self.reminder.photos[indexPath.row - 1] else {
                assertionFailure("oops, can't get image")
                return UITableViewCell()
            }
            cell.setupCell(image: image)
            cell.deleteButtonTapped = { [weak self] in
                self?.delegate.deleteImageButtonTapped(atIndex: indexPath.row - 1)
            }
            cell.isEditing = true
            return cell
        }
    }

    // MARK: - Настройка ячейки TableView с календарем

    func setupCellWithCalendar(tableView: UITableView,
                               indexPath: IndexPath) -> UITableViewCell {
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
    }

    // MARK: - Настройка ячейки TableView со временем

    func setupCellWithTime(tableView: UITableView,
                               indexPath: IndexPath) -> UITableViewCell {
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

    // MARK: - Настройка ячейки TableView с возможностью выбора варианта местоположения

    func setupCellWithLocationVariants(tableView: UITableView,
                                       indexPath: IndexPath,
                                       locationInfo: ReminderInfo.LocationInfo) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ReminderInfoLocationTableViewCell.reuseIdentifier,
                for: indexPath) as? ReminderInfoLocationTableViewCell else {
            assertionFailure("oops, something went wrong")
            return UITableViewCell()
        }

        cell.userCurrentLocationTapped = { [weak self] in
            self?.delegate.userCurrentLocationChosen()
        }
        cell.getInCarTapped = { [weak self] in
            self?.delegate.getInCarLocationChosen()
        }
        cell.getOutCarTapped = { [weak self] in
            self?.delegate.getOutCarLocationChosen()
        }
        cell.setupCell(chosenLocationType: locationInfo.chosenLocationType)
        return cell
    }

    // MARK: - Настройка ячейки TableView с текстом

    func setupCellWithText(tableView: UITableView,
                           indexPath: IndexPath,
                           locationInfo: ReminderInfo.LocationInfo) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AppConstants.TableViewCells.cellID, for: indexPath)
        cell.textLabel?.textColor = .systemGray4
        cell.selectionStyle = .none
        if locationInfo.chosenLocationType == .userCurrent {
            cell.textLabel?.text = locationInfo.chosenLocation
        } else {
            let text = locationInfo.chosenLocationType.rawValue
            cell.textLabel?.text = text
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    // MARK: - Настройка ячейки TableView с switch

    func setupCellWithSwitch(tableView: UITableView,
                             indexPath: IndexPath) -> UITableViewCell {
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
        if indexPath.section == 1 {
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
                // Ячейка с календарем
                return self.setupCellWithCalendar(tableView: tableView,
                                                  indexPath: indexPath)
            } else if indexPath.row == 3 {
                // Ячейка с часами
                return self.setupCellWithTime(tableView: tableView,
                                              indexPath: indexPath)
            }
        } else if indexPath.section == 2 {
            // MARK: - Местоположение
            let locationInfo = self.reminderInfo.locationInfo
            text = locationInfo.stringRepresentation[indexPath.row]
            image = locationInfo.image
            imageBackgroundColor = locationInfo.imageColor
            isSwitchActive = locationInfo.locationIsShowing
            if  indexPath.row == 1 {
                // Ячейка с вариантами местоположений
                return self.setupCellWithLocationVariants(tableView: tableView,
                                                          indexPath: indexPath,
                                                          locationInfo: locationInfo)
            } else if indexPath.row == 2 {
                // Ячейка с описанием выбранного пункта меспоположения
                return self.setupCellWithText(tableView: tableView,
                                              indexPath: indexPath,
                                              locationInfo: locationInfo)
            }
        } else if indexPath.section == 3 {
            // MARK: - Сообщения
            let messagingInfo = self.reminderInfo.messagingInfo
            text = messagingInfo.stringRepresentation[indexPath.row]
            image = messagingInfo.image
            imageBackgroundColor = messagingInfo.imageColor
        } else if indexPath.section == 4 {
            // MARK: - Флаг
            let flagInfo = self.reminderInfo.flagInfo
            text = flagInfo.stringRepresentation[indexPath.row]
            image = flagInfo.image
            imageBackgroundColor = flagInfo.imageColor
            isSwitchActive = self.reminder.flag
        }
        secondCell.setupCell(tableView: tableView,
                             text: text,
                             image: image,
                             imageBackgroundColor: imageBackgroundColor,
                             isSwitchActive: isSwitchActive)
        secondCell.switchValueDidChange = { [weak self] (value) in
            self?.delegate.switchValueDidChange(indexPath: indexPath, value: value)
        }
        return secondCell
    }
}
