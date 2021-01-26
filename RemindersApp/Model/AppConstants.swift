//
//  AppConstants.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import UIKit

enum AppConstants {
    enum AppFonts {
        static let reminderFont = UIFont.systemFont(ofSize: 16)
    }

    enum Constraints {
        static let doubleConstraint: CGFloat = 32
        static let normalConstraint: CGFloat = 16
        static let halfNormalConstraint: CGFloat = 8
        static let quarterNormalConstraint: CGFloat = 4
    }

    enum Images {
        static let circleImage = UIImage(systemName: "circle")
        static let infoImage = UIImage(systemName: "info.circle")
        static let calendarImage = UIImage(systemName: "calendar")
        static let clockImage = UIImage(systemName: "clock.fill")
        static let locationFillImage = UIImage(systemName: "location.fill")
        static let messageFillImage = UIImage(systemName: "message.fill")
        static let flagFillImage = UIImage(systemName: "flag.fill")
        static let rightArrowImage = UIImage(systemName: "chevron.right")
    }

    enum Sizes {
        static let isDoneButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let infoButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let reminderInfoIconImageSize: CGSize = CGSize(width: 25, height: 25)
        static let reminderInfoIconCornerRadius: CGFloat = 5
        static let reminderInfoPriorityImageSize: CGSize = CGSize(width: 10, height: 15)
    }
}
