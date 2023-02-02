//
//  ResultTableViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setProperty(data: ResultModel) {
        keyLabel.text = data.key + ": "
        valueLabel.text = data.value
    }
}
