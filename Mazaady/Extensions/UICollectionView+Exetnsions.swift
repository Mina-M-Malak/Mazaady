//
//  UICollectionView+Exetnsions.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

extension UICollectionView {
    func registerCell<cell: UICollectionViewCell>(collectionViewCell: cell.Type){
        self.register(UINib(nibName: String(describing: collectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: collectionViewCell.self))
    }
}
