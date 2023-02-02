//
//  ItemDetailsViewController.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    enum Sections: CaseIterable {
        case item
        case buyer
        case seller
        case recommended
    }
    
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet weak var priceTextField: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        regiseterTableViewCells()
    }
    
    private func setupUI() {
        priceTextField.makeRoundedCornersWith(radius: 8.0)
        itemDetailsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 168, right: 0)
    }
    
    private func regiseterTableViewCells() {
        itemDetailsTableView.registerCell(tabelViewCell: ItemDetailsTableViewCell.self)
        itemDetailsTableView.registerCell(tabelViewCell: BuyerTableViewCell.self)
        itemDetailsTableView.registerCell(tabelViewCell: SellerTableViewCell.self)
        itemDetailsTableView.registerCell(tabelViewCell: RecommendedItemsTableViewCell.self)
    }
}

//MARK: - UITableViewDataSource
extension ItemDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections.allCases[section]{
        case .buyer:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections.allCases[indexPath.section] {
        case .item:
            let cell = tableView.dequeueCell(tabelViewCell: ItemDetailsTableViewCell.self, indexPath: indexPath)
            return cell
        case .buyer:
            let cell = tableView.dequeueCell(tabelViewCell: BuyerTableViewCell.self, indexPath: indexPath)
            return cell
        case .seller:
            let cell = tableView.dequeueCell(tabelViewCell: SellerTableViewCell.self, indexPath: indexPath)
            return cell
        case .recommended:
            let cell = tableView.dequeueCell(tabelViewCell: RecommendedItemsTableViewCell.self, indexPath: indexPath)
            return cell
        }
    }
}
