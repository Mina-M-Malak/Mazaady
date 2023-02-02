//
//  ItemDetailsTableViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class ItemDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemVideosCollectionView: UICollectionView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        registerCells()
    }
    
    private func setupUI() {
        buyButton.makeRoundedCornersWith(radius: 8.0)
        cancelButton.makeRoundedCornersWith(radius: 8.0)
        dateView.makeRoundedCornersWith(radius: 16.0)
        dateView.setShadow(shadowColoe: .gray, cornerRadius: 16.0, shadowRadius: 2.0, shadowOpacity: 0.5, width: 0, height: 1.0)
    }
    
    private func registerCells() {
        itemVideosCollectionView.delegate = self
        itemVideosCollectionView.dataSource = self
        itemVideosCollectionView.registerCell(collectionViewCell: ItemVideosCollectionViewCell.self)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ItemDetailsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemVideosCollectionViewCell.self), for: indexPath) as! ItemVideosCollectionViewCell
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ItemDetailsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
