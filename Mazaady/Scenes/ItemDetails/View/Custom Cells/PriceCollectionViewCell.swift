//
//  PriceCollectionViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class PriceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        mainView.makeRoundedCornersWith(radius: 8.0)
    }
}
