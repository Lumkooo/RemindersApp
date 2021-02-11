//
//  ImagesViewController.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/8/21.
//

import UIKit

final class ImagesViewController: UIViewController {

    // MARK: - Properties

    private var photos: [UIImage?]
    private var imageIndex: Int

    // MARK: - Views

    private lazy var carouselScrollView: UIScrollView = {
        let myScrollView = UIScrollView()
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.isPagingEnabled = true
        return myScrollView
    }()

    private lazy var closeButton: UIButton = {
        let myButton = UIButton()
        myButton.tintColor = .white
        myButton.addTarget(self,
                           action: #selector(closeButtonTapped),
                           for: .touchUpInside)
        myButton.setImage(AppConstants.Images.xmarCircleFillImage,
                          for: .normal)
        return myButton
    }()

    // MARK: - Init

    init(photos: [UIImage?], imageIndex: Int) {
        self.photos = photos
        self.imageIndex = imageIndex
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Life cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.carouselScrollView.subviews {
            view.removeFromSuperview()
        }
        self.setupElements()
    }

    // MARK: - Обработка нажатий на кнопки

    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UISetup

private extension ImagesViewController {

    func setupElements() {
        self.setupCarouselScrollView()
        self.setupCloseButton()
    }

    func setupCarouselScrollView() {

        for index in 0..<photos.count {
            // calcuate the horizontal offset
            let offset = index == 0 ? 0 : (CGFloat(index) * self.view.frame.width)
            let imgView = UIImageView(frame: CGRect(x: offset,
                                                    y: 0,
                                                    width: self.view.frame.width,
                                                    height: self.view.frame.height))
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFit
            imgView.image = photos[index]
            self.carouselScrollView.addSubview(imgView)
        }
        self.carouselScrollView.contentSize = CGSize(width: CGFloat(photos.count) * self.view.frame.width,
                                                height: self.view.frame.height)
        self.view.addSubview(carouselScrollView)
        self.carouselScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.carouselScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.carouselScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.carouselScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.carouselScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.setupCarouselScrollViewContentOffset()
    }

    func setupCarouselScrollViewContentOffset() {
        let contentOffset = CGPoint(x: CGFloat(self.imageIndex) * self.view.frame.width,
                                    y: 0)
        self.carouselScrollView.setContentOffset(contentOffset, animated: false)
    }

    func setupCloseButton() {
        self.view.addSubview(self.closeButton)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.closeButton.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                constant: -AppConstants.Constraints.normalConstraint),
            self.closeButton.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: AppConstants.Constraints.normalConstraint)
        ])
    }
}
