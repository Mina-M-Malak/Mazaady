//
//  RecommendedItemsTableViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class RecommendedItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var recommendedItemsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        recommendedItemsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        recommendedItemsCollectionView.dataSource = self
        recommendedItemsCollectionView.delegate = self
        recommendedItemsCollectionView.registerCell(collectionViewCell: RecommendedItemCollectionViewCell.self)
    }
}

//MARK: - UICollectionViewDataSource
extension RecommendedItemsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendedItemCollectionViewCell.self), for: indexPath) as! RecommendedItemCollectionViewCell
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension RecommendedItemsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2 ), height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
