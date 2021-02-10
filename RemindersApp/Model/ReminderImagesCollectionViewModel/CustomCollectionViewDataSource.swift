//
//  CustomCollectionViewDataSource.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/7/21.
//

import UIKit

final class CustomCollectionViewDataSource: NSObject {

    // MARK: - Properties

    var imagesArray: [UIImage?] = []

}

// MARK: - UICollectionViewDataSource

extension CustomCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReminderImagesCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ReminderImagesCollectionViewCell else {
            assertionFailure("oops, error occured")
            return UICollectionViewCell()
        }

        if let image = self.imagesArray[indexPath.row] {
            cell.setupCell(image: image)
        }

        return cell
    }
}
