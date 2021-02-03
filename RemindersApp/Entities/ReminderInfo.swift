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
                    self.stringRepresentation.append("Нажмите для выбора даты")
                }  else {
                    if self.timeIsShowing == true {
                        self.timeIsShowing = false
                    }
                    self.stringRepresentation.removeAll { (string) -> Bool in
                        string == "Нажмите для выбора даты"
                    }
                }
            }
        }
        var timeIsShowing: Bool {
            willSet {
                if newValue == true {
                    if self.calendarIsShowing == false {
                        self.calendarIsShowing = true
                    }
                    self.stringRepresentation.append("Выберите время")
                }  else {
                    self.stringRepresentation.removeAll { (string) -> Bool in
                        string == "Выберите время"
                    }
                }
            }
        }

        init() {
            self.stringRepresentation = ["Дата", "Время"]
            self.image = [AppConstants.Images.calendarImage ?? UIImage(),
                          AppConstants.Images.calendarImage ?? UIImage()]
            self.imageColors = [.red, .systemBlue, .systemBlue]
            self.calendarIsShowing = false
            self.timeIsShowing = false
        }
    }

    // MARK: - LocationInfo

    struct LocationInfo {
        var stringRepresentation: [String]
        let image: UIImage
        let imageColor: UIColor
        var chosenLocationType: ChosenLocationType = .userCurrent
        var chosenLocation: String
        var locationIsShowing: Bool {
            willSet {
                if newValue == true {
                    self.stringRepresentation.append("Выберите местоположение")
                    self.stringRepresentation.append("Выбранный вариант:")
                }  else {
                    self.stringRepresentation.removeAll { (string) -> Bool in
                        string == "Выберите местоположение"
                    }
                    self.stringRepresentation.removeAll { (string) -> Bool in
                        string == "Выбранный вариант:"
                    }
                }
            }
        }

        init() {
            self.stringRepresentation = ["Местоположение"]
            self.image = AppConstants.Images.locationFillImage ?? UIImage()
            self.imageColor = .systemBlue
            self.locationIsShowing = false
            self.chosenLocation = ""
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

