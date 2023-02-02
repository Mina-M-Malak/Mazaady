//
//  ItemDetailsViewController.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet weak var priceTextField: BaseTextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var pricesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        regiseterCells()
    }
    
    private func setupUI() {
        priceTextField.makeRoundedCornersWith(radius: 8.0)
        itemDetailsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 168, right: 0)
        priceView.setShadow(shadowColoe: .gray, cornerRadius: 0, shadowRadius: 2.0, shadowOpacity: 0.5, width: 0, height: 0)
    }
    
    private func regiseterCells() {
        itemDetailsTableView.registerCell(tabelViewCell: ItemDetailsTableViewCell.self)
        itemDetailsTableView.registerCell(tabelViewCell: BuyerTableViewCell.self)
        itemDetailsTableView.registerCell(tabelViewCell: SellerTableViewCell.self)
        itemDetailsTableView.registerCell(tabelViewCell: RecommendedItemsTableViewCell.self)
        
        itemDetailsTableView.registerHeader(header: BuyerSectionHeaderView.self)
        
        pricesCollectionView.registerCell(collectionViewCell: PriceCollectionViewCell.self)
    }
    
    private func getCell<t: UITableViewCell>(indexPath: IndexPath) -> t {
        switch DetailsSections.allCases[indexPath.section] {
        case .item:
            return itemDetailsTableView.dequeueCell(tabelViewCell: ItemDetailsTableViewCell.self, indexPath: indexPath) as! t
        case .buyer:
            return  itemDetailsTableView.dequeueCell(tabelViewCell: BuyerTableViewCell.self, indexPath: indexPath) as! t
        case .seller:
            return  itemDetailsTableView.dequeueCell(tabelViewCell: SellerTableViewCell.self, indexPath: indexPath) as! t
        case .recommended:
            return  itemDetailsTableView.dequeueCell(tabelViewCell: RecommendedItemsTableViewCell.self, indexPath: indexPath) as! t
        }
    }
}

//MARK: - UITableViewDataSource
extension ItemDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailsSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch DetailsSections.allCases[section]{
        case .buyer:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        getCell(indexPath: indexPath)
    }
}


//MARK: - UITableViewDelegate
extension ItemDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard DetailsSections.allCases[section] == .buyer else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: BuyerSectionHeaderView.self)) as! BuyerSectionHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard DetailsSections.allCases[section] == .buyer else { return 0 }
        return 44
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ItemDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PriceCollectionViewCell.self), for: indexPath) as! PriceCollectionViewCell
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ItemDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
