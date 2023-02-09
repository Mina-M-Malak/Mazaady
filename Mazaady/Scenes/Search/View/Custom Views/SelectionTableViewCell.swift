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
    
    func setCategory(category: Category?) {
        propertyLabel.text = category?.name
    }
    
    func setSubcategory(subcategory: Subcategory?) {
        propertyLabel.text = subcategory?.name
    }
    
    func setOption(option: Option?) {
        propertyLabel.text = option?.name
    }
    
    func setCheckMark(isSelected: Bool) {
        accessoryType = isSelected ? .checkmark : .none
    }
}
