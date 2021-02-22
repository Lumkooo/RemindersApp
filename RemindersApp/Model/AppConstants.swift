//
//  AppConstants.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import UIKit

enum AppConstants {
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenWidth = UIScreen.main.bounds.size.width

    enum AppFonts {
        static let reminderFont: UIFont = .systemFont(ofSize: 16)
        static let reminderNotesFont: UIFont = .systemFont(ofSize: 14)
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
        static let largeCircleFillImage = UIImage(systemName: "largecircle.fill.circle")
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
        static let locationImage = UIImage(systemName: "location.fill")
        static let carImage = UIImage(systemName: "car")
        static let checkmarkImage = UIImage(systemName: "checkmark")
        static let photoImage = UIImage(systemName: "photo")
        static let cameraImage = UIImage(systemName: "camera")
        static let minusCircleFillImage = UIImage(systemName: "minus.circle.fill")
        static let safariFillImage = UIImage(systemName: "safari.fill")
        static let ellipsisCircleImage = UIImage(systemName: "ellipsis.circle")
        static let eyeSlashImage = UIImage(systemName: "eye.slash")
        static let eyeImage = UIImage(systemName: "eye")
    }

    enum Sizes {
        static let isDoneButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let infoButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let reminderInfoIconImageSize: CGSize = CGSize(width: 25, height: 25)
        static let reminderInfoPriorityImageSize: CGSize = CGSize(width: 10, height: 15)
        static let locationButtonSize: CGSize = CGSize(width: AppConstants.screenHeight/15,
                                                       height: AppConstants.screenHeight/15)
        static let reminderInfoImageSize: CGSize = CGSize(width: 50,
                                                       height: 50)
        static let reminderInfoDeletingButtonSize: CGSize = CGSize(width: 20,
                                                       height: 20)

        static let reminderInfoIconCornerRadius: CGFloat = 5
        static let calendarCornerRadius: CGFloat = 15
        static let separatorViewAlpha: CGFloat = 0.2
        static let calendarHeaderHeight: CGFloat = 85
        static let calendarFooterHeight: CGFloat = 60
        static let locationDescriptionButtonCornerRadius: CGFloat = 5
        static let locationDescriptionButtonHeight: CGFloat = 20
        static let reminderInfoImageCornerRadius: CGFloat = 12
        static let reminderImageCornerRadius: CGFloat = 6
    }

    enum TableViewCells {
        static let cellID = "cellID"
    }

    enum AnimationTimes {
        static let reloadTableView: Double = 0.1
    }

    // MARK: - CollectionViewSize

    enum CollectionViewSize {
        static let reminderImagesCollectionViewSize = CGSize(
            width: 35,
            height: 35)
    }

    enum UserDefaultsKeys {
        static let isShowingCompletedKey = "isShowingCompleted"
    }
}
