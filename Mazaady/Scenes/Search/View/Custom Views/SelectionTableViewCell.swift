//
//  SelectionTableViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var propertyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setOption(option: Option) {
        propertyLabel.text = option.name
    }
}
