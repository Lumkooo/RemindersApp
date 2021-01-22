//
//  HideKeyboardExtension.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/22/21.
//

import UIKit

extension UIViewController {
    func setupHidingKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
