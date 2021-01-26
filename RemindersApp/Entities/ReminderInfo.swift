//
//  ReminderInfo.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/25/21.
//

import UIKit

struct ReminderInfo {
    var mainInfo: [String] = ["Заголовок", "Заметки", "URL"]
    var dateAndTimeInfo = DateAndTimeInfo()
    var locationInfo = LocationInfo()
    var messagingInfo = MessagingInfo()
    var flagInfo = FlagInfo()
    var priorityInfo: [String] = ["Приоритет"]
    var addImageInfo: [String] = ["Добавить изображение"]

    // MARK: - DateAndTimeInfo

    struct DateAndTimeInfo {
        var stringRepresentation: [String]
        let image: [UIImage]
        let imageColors: [UIColor]
        var calendarIsShowing: Bool {
            willSet {
                if newValue == true {
                    self.stringRepresentation.insert("Календарь", at: 1)
                }  else {
                    self.stringRepresentation.remove(at: 1)
                }
            }
        }
        var timeIsShowing: Bool

        init() {
            self.stringRepresentation = ["Дата", "Время"]
            self.image = [AppConstants.Images.calendarImage ?? UIImage(),
                          AppConstants.Images.calendarImage ?? UIImage(),
                          AppConstants.Images.clockImage ?? UIImage()]
            self.imageColors = [.red, .systemBlue, .systemBlue]
            self.calendarIsShowing = false
            self.timeIsShowing = false
        }
    }

    // MARK: - LocationInfo

    struct LocationInfo {
        let stringRepresentation: [String]
        let image: UIImage
        let imageColor: UIColor
        init() {
            self.stringRepresentation = ["Местоположение"]
            self.image = AppConstants.Images.locationFillImage ?? UIImage()
            self.imageColor = .systemBlue
        }
    }

    // MARK: - MessagingInfo

    struct MessagingInfo {
        let stringRepresentation: [String]
        let image: UIImage
        let imageColor: UIColor
        init() {
            self.stringRepresentation = ["По сообщению"]
            self.image = AppConstants.Images.messageFillImage ?? UIImage()
            self.imageColor = .green
        }
    }

    // MARK: - FlagInfo

    struct FlagInfo {
        let stringRepresentation: [String]
        let image: UIImage
        let imageColor: UIColor
        init() {
            self.stringRepresentation = ["Флаг"]
            self.image = AppConstants.Images.flagFillImage ?? UIImage()
            self.imageColor = .orange
        }
    }
}

