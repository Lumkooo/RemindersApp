//
//  RemindersListTableViewCell.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 1/21/21.
//

import UIKit

final class RemindersListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: RemindersListTableViewCell.self)
    }
    private weak var parentTableView: UITableView?
    private var cellIndex: Int = 0
    private var collectionViewDelegate: CustomCollectionViewDelegate?
    private var collectionViewDataSource: CustomCollectionViewDataSource?
    var isDoneButtonTapped: (() -> Void)?
    var infoButtonTapped: (() -> Void)?
    var textViewDidChange: ((Int, String) -> Void)?

    // MARK: - Views

    private let reminderTextView: UITextView = {
        let myTextView = UITextView()
        myTextView.font = AppConstants.AppFonts.reminderFont
        myTextView.isScrollEnabled = false
        return myTextView
    }()

    private lazy var reminderNotesLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textColor = .lightGray
        myLabel.textAlignment = .natural
        myLabel.font = AppConstants.AppFonts.reminderNotesFont
        myLabel.numberOfLines = 0
        return myLabel
    }()

    private lazy var reminderImagesCollectionView: UICollectionView = {
        let myCollectionView:UICollectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewFlowLayout.init())
        myCollectionView.register(ReminderImagesCollectionViewCell.self,
                                  forCellWithReuseIdentifier: ReminderImagesCollectionViewCell.reuseIdentifier)
        return myCollectionView
    }()

    private lazy var isDoneButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.circleImage, for: .normal)
        myButton.tintColor = .systemGray
        myButton.addTarget(self,
                           action: #selector(isDoneButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myButton
    }()

    private lazy var infoButton: UIButton = {
        let myButton = UIButton()
        myButton.setImage(AppConstants.Images.infoImage, for: .normal)
        myButton.addTarget(self,
                           action: #selector(infoButtonTapped(gesture:)),
                           for: .touchUpInside)
        return myButton
    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupElements()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    func setupCell(tableView: UITableView, cellIndex: Int, reminder: Reminder) {
        self.reminderTextView.text = reminder.text
        if let note = reminder.note {
            self.reminderNotesLabel.text = note
        }
        self.parentTableView = tableView
        self.cellIndex = cellIndex
        self.collectionViewDataSource?.imagesArray = reminder.photos
        if reminder.photos.count > 0 {
            self.reminderImagesCollectionView.heightAnchor.constraint(
                equalToConstant: AppConstants.CollectionViewSize.reminderImagesCollectionViewSize.height).isActive = true
        }
        self.reminderImagesCollectionView.reloadData()
    }

    // MARK: - Buttons action methods

    @objc private func infoButtonTapped(gesture: UIGestureRecognizer) {
        self.infoButtonTapped?()
    }

    @objc private func isDoneButtonTapped(gesture: UIGestureRecognizer) {
        self.isDoneButtonTapped?()
    }
}

// MARK: - UISetup

private extension RemindersListTableViewCell {
    func setupElements() {
        self.setupIsDoneButton()
        self.setupInfoButton()
        self.setupReminderTextView()
        self.setupReminderNotesLabel()
        self.setupReminderImagesCollectionView()
    }

    func setupIsDoneButton() {
        self.contentView.addSubview(self.isDoneButton)
        self.isDoneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.isDoneButton.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor),
            self.isDoneButton.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.isDoneButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.isDoneButtonSize.height),
            self.isDoneButton.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.isDoneButtonSize.width)
        ])
    }

    func setupInfoButton() {
        self.contentView.addSubview(self.infoButton)
        self.infoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.infoButton.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint),
            self.infoButton.centerYAnchor.constraint(
                equalTo: self.contentView.centerYAnchor),
            self.infoButton.heightAnchor.constraint(
                equalToConstant: AppConstants.Sizes.infoButtonSize.height),
            self.infoButton.widthAnchor.constraint(
                equalToConstant: AppConstants.Sizes.infoButtonSize.width)
        ])
    }

    func setupReminderTextView() {
        self.contentView.addSubview(self.reminderTextView)
        self.reminderTextView.translatesAutoresizingMaskIntoConstraints = false
        self.reminderTextView.delegate = self
        self.reminderTextView.backgroundColor = self.backgroundColor
        NSLayoutConstraint.activate([
            self.reminderTextView.leadingAnchor.constraint(
                equalTo: self.isDoneButton.trailingAnchor,
                constant: AppConstants.Constraints.quarterNormalConstraint),
            self.reminderTextView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.reminderTextView.trailingAnchor.constraint(
                equalTo: self.infoButton.leadingAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint)
        ])
    }

    func setupReminderNotesLabel() {
        self.contentView.addSubview(self.reminderNotesLabel)
        self.reminderNotesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.reminderNotesLabel.leadingAnchor.constraint(
                equalTo: self.isDoneButton.trailingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.reminderNotesLabel.topAnchor.constraint(
                equalTo: self.reminderTextView.bottomAnchor,
                constant: AppConstants.Constraints.quarterNormalConstraint),
            self.reminderNotesLabel.trailingAnchor.constraint(
                equalTo: self.infoButton.leadingAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint)
        ])
    }

    func setupReminderImagesCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: AppConstants.Constraints.normalConstraint,
                                           bottom: 0,
                                           right: AppConstants.Constraints.normalConstraint)
        self.reminderImagesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.reminderImagesCollectionView.backgroundColor = .clear
        self.collectionViewDelegate = CustomCollectionViewDelegate(delegate: self)
        self.collectionViewDataSource = CustomCollectionViewDataSource()
        self.reminderImagesCollectionView.delegate = self.collectionViewDelegate
        self.reminderImagesCollectionView.dataSource = self.collectionViewDataSource
        self.contentView.addSubview(self.reminderImagesCollectionView)
        self.reminderImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.reminderImagesCollectionView.leadingAnchor.constraint(
                equalTo: self.isDoneButton.trailingAnchor,
                constant: AppConstants.Constraints.halfNormalConstraint),
            self.reminderImagesCollectionView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -AppConstants.Constraints.quarterNormalConstraint),
            self.reminderImagesCollectionView.topAnchor.constraint(
                equalTo: self.reminderNotesLabel.bottomAnchor,
                constant: AppConstants.Constraints.quarterNormalConstraint),
            self.reminderImagesCollectionView.trailingAnchor.constraint(
                equalTo: self.infoButton.leadingAnchor,
                constant: -AppConstants.Constraints.halfNormalConstraint)
        ])
    }
}

// MARK: - UITextViewDelegate

extension RemindersListTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.parentTableView?.beginUpdates()
        self.parentTableView?.endUpdates()
        guard let text = textView.text else {
            return
        }
        self.textViewDidChange?(self.cellIndex,
                                text)
    }

    func setSelected(selected: Bool, animated: Bool) {
        self.reminderTextView.becomeFirstResponder()
    }
}

// MARK: - ICustomCollectionViewDelegate

extension RemindersListTableViewCell: ICustomCollectionViewDelegate {
    func didSelectItemAt(_ indexPath: IndexPath) {
        // TODO: - Показать картинку на весь экран с возможностью листать между картинками
        print("selected at index: ", indexPath.row)
    }
}
