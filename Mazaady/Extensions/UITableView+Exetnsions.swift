//
//  UITableView+Exetnsions.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

extension UITableView {
    func registerCell<cell: UITableViewCell>(tabelViewCell: cell.Type){
        self.register(UINib(nibName: String(describing: tabelViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: tabelViewCell.self))
    }
    
    func dequeueCell<cell: UITableViewCell>(tabelViewCell: cell.Type, indexPath: IndexPath) -> cell {
        return dequeueReusableCell(withIdentifier: String(describing: tabelViewCell.self), for: indexPath) as! cell
    }
}
