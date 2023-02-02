//
//  RecommendedItemCollectionViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class RecommendedItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        mainView.setBorderColor(color: .lightGray, width: 0.5)
        mainView.makeRoundedCornersWith(radius: 8.0)
        itemImageView.makeRoundedCornersWith(radius: 8.0)
        typeLabel.makeRoundedCornersWith(radius: 4.0)
        favoriteButton.makeRoundedCorners()
    }
}
