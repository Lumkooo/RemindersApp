//
//  AppConstants.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import UIKit

enum AppConstants {
    enum AppFonts {
        static let reminderFont: UIFont = .systemFont(ofSize: 16)
        static let calendarButtonsFont: UIFont = .systemFont(ofSize: 17, weight: .medium)
        static let calendarDaysFont: UIFont = .systemFont(ofSize: 18, weight: .medium)
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
        static let chevronLeftImage = UIImage(systemName: "chevron.left.circle.fill")
        static let chevronRightImage = UIImage(systemName: "chevron.right.circle.fill")
        static let xmarCircleFillImage = UIImage(systemName: "xmark.circle.fill")
    }

    enum Sizes {
        static let isDoneButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let infoButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let reminderInfoIconImageSize: CGSize = CGSize(width: 25, height: 25)
        static let reminderInfoIconCornerRadius: CGFloat = 5
        static let reminderInfoPriorityImageSize: CGSize = CGSize(width: 10, height: 15)
        static let calendarCornerRadius: CGFloat = 15
        static let separatorViewAlpha: CGFloat = 0.2
        static let calendarHeaderHeight: CGFloat = 85
        static let calendarFooterHeight: CGFloat = 60
        static let datePickerMinimumSize: CGSize = CGSize(width: 280, height: 280)
    }

    enum TableViewCells {
        static let cellID = "cellID"
    }
}
