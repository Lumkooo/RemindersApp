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
    }

    enum Sizes {
        static let isDoneButtonSize: CGSize = CGSize(width: 35, height: 35)
        static let infoButtonSize: CGSize = CGSize(width: 35, height: 35)
    }
}
