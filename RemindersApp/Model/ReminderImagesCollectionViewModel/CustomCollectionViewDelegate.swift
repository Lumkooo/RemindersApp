//
//  CustomCollectionViewDelegate.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/7/21.
//

import UIKit

protocol ICustomCollectionViewDelegate {
    func didSelectItemAt(_ indexPath: IndexPath)
}

final class CustomCollectionViewDelegate: NSObject {

    // MARK: - Properties

    private var delegate: ICustomCollectionViewDelegate

    // MARK: - Init

    init(delegate: ICustomCollectionViewDelegate) {
        self.delegate = delegate
    }
}

// MARK: - UICollectionViewDelegate

extension CustomCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.didSelectItemAt(indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CustomCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: AppConstants.CollectionViewSize.reminderImagesCollectionViewSize.width,
            height: AppConstants.CollectionViewSize.reminderImagesCollectionViewSize.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        AppConstants.Constraints.halfNormalConstraint
    }
}
