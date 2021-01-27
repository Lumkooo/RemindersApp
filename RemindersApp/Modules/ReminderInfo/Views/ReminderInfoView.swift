//
//  ReminderInfoView.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/26/21.
//

import UIKit

protocol IReminderInfoView: AnyObject {

}

final class ReminderInfoView: UIView {

    // MARK: - Views

//    private lazy var mainReminderInfoView = MainReminderInfoView()
//    private lazy var secondMainReminderInfoView = MainReminderInfoView()
//
//    private lazy var stackView: UIStackView = {
//        let myStackView = UIStackView()
//        myStackView.axis  = NSLayoutConstraint.Axis.vertical
//        myStackView.distribution  = UIStackView.Distribution.equalSpacing
//        myStackView.alignment = UIStackView.Alignment.center
//        myStackView.spacing   = AppConstants.Constraints.normalConstraint
//        return myStackView
//    }()

    // MARK: - Properties


    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.setupElements()
        self.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - IReminderInfoView

extension ReminderInfoView: IReminderInfoView {

}

// MARK: - UISetup

private extension ReminderInfoView {
    func setupElements() {
//        self.setupStackView()
//        self.setupView()

    }

//    func setupView() {
//        self.addSubview(self.mainReminderInfoView)
//        self.mainReminderInfoView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.mainReminderInfoView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
//            self.mainReminderInfoView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
//            self.mainReminderInfoView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
//            self.mainReminderInfoView.heightAnchor.constraint(equalTo: self.heightAnchor,
//                                                              multiplier: 1/2)
//        ])
//    }
//
//    func setupStackView() {
//        self.stackView.addArrangedSubview(self.mainReminderInfoView)
//        self.stackView.addArrangedSubview(self.secondMainReminderInfoView)
//        self.addSubview(self.stackView)
//        self.stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            self.stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
//            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
//            self.stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
//            self.stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
//        ])
//    }
}
