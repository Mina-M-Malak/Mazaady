//
//  ItemDetailsTableViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class ItemDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        buyButton.makeRoundedCornersWith(radius: 8.0)
        cancelButton.makeRoundedCornersWith(radius: 8.0)
        dateView.makeRoundedCornersWith(radius: 16.0)
        dateView.setShadow(shadowColoe: .gray, cornerRadius: 16.0, shadowRadius: 2.0, shadowOpacity: 0.5, width: 0, height: 1.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
