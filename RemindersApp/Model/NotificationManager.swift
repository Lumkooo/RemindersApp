//
//  NotificationManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/14/21.
//

import Foundation
import UserNotifications
import MobileCoreServices


final class NotificationManager {

    // MARK: - Properties

    private let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Init

    init(delegate: UNUserNotificationCenterDelegate) {
        self.notificationCenter.delegate = delegate
    }

    // MARK: Public func


    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        self.notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }

    func createNotification(for reminder: Reminder){
        let notificationIdetifier = "local_notification_\(reminder.uID)"
        let categoryIdentifier = "Delete Notification Type"

        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdetifier])

        guard let fireDate = reminder.date else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "Напоминание!"
        content.body = "\(reminder.text)"
        content.categoryIdentifier = categoryIdentifier
        content.sound = UNNotificationSound.default
        content.badge = 1
        if !reminder.photosURL.isEmpty {
            let photoURL = reminder.photosURL[0]
            do {
                let attachment = try UNNotificationAttachment(identifier: "\(reminder.uID)_attachment_identifier", url: photoURL, options: [:])
                content.attachments = [attachment]
            } catch let error {
                assertionFailure("error occured, \(error)")
            }
        }
        let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year,
                                                                 Calendar.Component.month,
                                                                 Calendar.Component.day,
                                                                 Calendar.Component.hour,
                                                                 Calendar.Component.minute),
                                                             from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdetifier,
                                            content: content,
                                            trigger: trigger)
        self.notificationCenter.add(request, withCompletionHandler: { error in
                if let _ = error {
                    // Error
                } else {
                    //notification set up successfully
                }
        })
    }
}
