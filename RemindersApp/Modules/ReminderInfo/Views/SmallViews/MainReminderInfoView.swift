//
//  MainReminderInfoView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/27/21.
//

import UIKit

final class MainReminderInfoView: UIView {

    // MARK: - Proprties

    // MARK: - Views

//    private lazy var stackView: UIStackView = {
//        let myStackView = UIStackView()
//        myStackView.axis  = NSLayoutConstraint.Axis.horizontal
//        myStackView.distribution  = UIStackView.Distribution.fillEqually
//        myStackView.alignment = UIStackView.Alignment.leading
//        myStackView.spacing   = AppConstants.Constraints.normalConstraint
//        return myStackView
//    }()

    private lazy var reminderTextView: UITextView = {
        let myTextView = UITextView()
        myTextView.text = "WOW"
        return myTextView
    }()

    private lazy var notesTextView: UITextView = {
        let myTextView = UITextView()
        return myTextView
    }()

    private lazy var urlTextView: UITextField = {
        let myTextField = UITextField()
        return myTextField
    }()

    private let myButton: UIButton = {
        let myButton = UIButton()
        myButton.setTitle("Tap me", for: .normal)
        myButton.backgroundColor = .red
        myButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        return myButton
    }()

    @objc private func tapped() {
        print("tapped")
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        self.setupElements()
        self.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//  MARK: - UISetup

private extension MainReminderInfoView {
    func setupElements() {
        self.setupReminderTextView()
        self.setupNotesTextView()
        self.setupURLTextView()
    }

//    func setupStackView() {
//        self.addSubview(self.myButton)
//        self.myButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.myButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            self.myButton.topAnchor.constraint(equalTo: self.topAnchor),
//            self.myButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            self.myButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3)
//        ])
//    }

    func setupReminderTextView() {
        self.addSubview(self.reminderTextView)
        self.reminderTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.reminderTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.reminderTextView.topAnchor.constraint(equalTo: self.topAnchor,
                                                       constant: AppConstants.Constraints.normalConstraint),
            self.reminderTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.reminderTextView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3)
        ])
    }

    func setupNotesTextView() {
        self.addSubview(self.notesTextView)
        self.notesTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.notesTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.notesTextView.topAnchor.constraint(equalTo: self.reminderTextView.bottomAnchor,
                                                    constant: AppConstants.Constraints.normalConstraint),
            self.notesTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.notesTextView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3)
        ])
    }

    func setupURLTextView() {
        self.addSubview(self.urlTextView)
        self.urlTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.urlTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.urlTextView.topAnchor.constraint(equalTo: self.notesTextView.bottomAnchor,
                                                  constant: AppConstants.Constraints.normalConstraint),
            self.urlTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
