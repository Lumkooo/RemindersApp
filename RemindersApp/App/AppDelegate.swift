//
//  AppDelegate.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit
import CoreData
import UserNotifications
import MobileCoreServices


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.notificationCenter.delegate = self

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        self.notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RemindersApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.list, .sound, .badge])
    }



    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }

        completionHandler()
    }

    func scheduleNotification(reminder: Reminder) {

        let notificationIdetifier = "local_notification_\(reminder.text)"
        let categoryIdentifier = "Delete Notification Type"
        // для того, чтобы поддерживать возможность изменения даты напоминания и самого напоминания
        // будем удалять напоминание из notificationCenter (если имеется)
        // и потом добавлять заново
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
                let attachment = try UNNotificationAttachment(identifier: "\(reminder.text)_attachment_identifier", url: photoURL, options: [:])
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
