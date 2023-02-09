//
//  SelectionView.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class SelectionView: TableFactoryCardView {
    
    override var cardViewHeight:CGFloat {
        let count = categories?.count ?? subcategories?.count ?? options?.count ?? 0
        guard count != 0 else { return 250}
        let value: CGFloat = CGFloat((count * 52) + 90)
        if value > (UIScreen.main.bounds.height * 0.75){
            return UIScreen.main.bounds.height * 0.75
        }
        return value
    }
    
    private var categories: [Category]?
    private var subcategories: [Subcategory]?
    private var options: [Option]?
    var didSelectItem: ((_ index: Int)->())?
    var type: SearchSections = .category
    private var selectedIndex: Int?
    
    init(categories: [Category],selectedCategoryIndex: Int?) {
        super.init(headerText: "", hasDoneButton: true)
        self.categories = categories
        self.selectedIndex = selectedCategoryIndex
    }
    
    init(subcategories: [Subcategory],selectedSubcategoryIndex: Int?) {
        super.init(headerText: "", hasDoneButton: true)
        self.subcategories = subcategories
        self.selectedIndex = selectedSubcategoryIndex
    }
    
    init(options: [Option],selectedOptionIndex: Int?) {
        super.init(headerText: "", hasDoneButton: true)
        self.options = options
        self.selectedIndex = selectedOptionIndex
    }
    
    override func setupViews() {
        super.setupViews()
        super.setTableDelegate(view: self)
        getTableView().registerCell(tabelViewCell: SelectionTableViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCell<t: UITableViewCell>(indexPath: IndexPath) -> t {
        let cell = tableView.dequeueCell(tabelViewCell: SelectionTableViewCell.self, indexPath: indexPath)
        switch type {
        case .category:
            cell.setCategory(category: categories?[indexPath.row])
        case .subcategory:
            cell.setSubcategory(subcategory: subcategories?[indexPath.row])
        case .option:
            cell.setOption(option: options?[indexPath.row])
        }
        cell.setCheckMark(isSelected: (indexPath.row == selectedIndex))
        return cell as! t
    }
}

//MARK: - UITableViewDataSource
extension SelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = categories?.count ?? subcategories?.count ?? options?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension SelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(indexPath.row)
    }
}
