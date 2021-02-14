//
//  CoreDataReminder+CoreDataProperties.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/14/21.
//
//

import Foundation
import CoreData


extension CoreDataReminder {

    @nonobjc public class func fetch() -> NSFetchRequest<CoreDataReminder> {
        return NSFetchRequest<CoreDataReminder>(entityName: "CoreDataReminder")
    }

    @NSManaged public var text: String
    @NSManaged public var uID: String
    @NSManaged public var note: String?
    @NSManaged public var url: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var date: Date?
    @NSManaged public var flag: Bool
    @NSManaged public var photos: Data?
    @NSManaged public var photosURL: Data?
    @NSManaged public var priority: String?

}

extension CoreDataReminder : Identifiable {

}
