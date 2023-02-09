//
//  SelectionView.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class SelectionView: TableFactoryCardView {
    
    override var cardViewHeight:CGFloat {
        return (UIScreen.main.bounds.height * 0.85)
    }
    
    private var customCategories: [Category]?
    private var customSubcategories: [Subcategory]?
    private var customOptions: [Option]?
    private var allCategories: [Category]?
    private var allSubcategories: [Subcategory]?
    private var allOptions: [Option]?
    var didSelectItem: ((_ index: Int)->())?
    var type: SearchSections = .category
    private var selectedIndex: Int?
    
    init(categories: [Category],selectedCategoryIndex: Int?) {
        super.init(headerText: "", hasDoneButton: true)
        allCategories = categories
        customCategories = categories
        selectedIndex = selectedCategoryIndex
    }
    
    init(subcategories: [Subcategory],selectedSubcategoryIndex: Int?) {
        super.init(headerText: "", hasDoneButton: true)
        allSubcategories = subcategories
        customSubcategories = subcategories
        selectedIndex = selectedSubcategoryIndex
    }
    
    init(options: [Option],selectedOptionIndex: Int?) {
        super.init(headerText: "", hasDoneButton: true)
        customOptions = options
        customOptions?.append(Option(id: 0, name: "Other", hasChild: false))
        allOptions = customOptions
        self.selectedIndex = selectedOptionIndex
    }
    
    override func setupViews() {
        super.setupViews()
        super.setTableDelegate(view: self)
        super.setSearchDelegate(view: self)
        getTableView().registerCell(tabelViewCell: SelectionTableViewCell.self)
        didClickOnDragView = { [weak self] in
            self?.searchBar.endEditing(true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getCell<t: UITableViewCell>(indexPath: IndexPath) -> t {
        let cell = tableView.dequeueCell(tabelViewCell: SelectionTableViewCell.self, indexPath: indexPath)
        var isSelected = (indexPath.row == selectedIndex)
        switch type {
        case .category:
            cell.setCategory(category: customCategories?[indexPath.row])
        case .subcategory:
            cell.setSubcategory(subcategory: customSubcategories?[indexPath.row])
        case .option:
            isSelected = (isSelected || (selectedIndex == -1 && ((indexPath.row == (customOptions?.count ?? 0) - 1))))
            cell.setOption(option: customOptions?[indexPath.row])
        }
        cell.setCheckMark(isSelected: isSelected)
        return cell as! t
    }
    
    private func handleSearch(searchText: String) {
        let isEmpty = searchText.trimmingCharacters(in: .whitespaces).isEmpty
        switch type {
        case .category:
            customCategories = isEmpty ? allCategories : allCategories?.filter({$0.name.lowercased().contains(searchText.lowercased())})
        case .subcategory:
            customSubcategories = isEmpty ? allSubcategories : allSubcategories?.filter({$0.name.lowercased().contains(searchText.lowercased())})
        case .option:
            customOptions = isEmpty ? allOptions : allOptions?.filter({$0.name.lowercased().contains(searchText.lowercased())})
        }
        tableView.reloadData()
    }
    
    private func handleItemSelection(index: Int) {
        searchBar.endEditing(true)
        var selectedIndex: Int?
        switch type {
        case .category:
            selectedIndex = allCategories?.firstIndex(where: {$0.id == customCategories?[index].id})
        case .subcategory:
            selectedIndex = allSubcategories?.firstIndex(where: {$0.id == customSubcategories?[index].id})
        case .option:
            selectedIndex = allOptions?.firstIndex(where: {$0.id == customOptions?[index].id})
        }
        guard let selectedIndex = selectedIndex else { return }
        didSelectItem?(selectedIndex)
    }
}

//MARK: - UITableViewDataSource
extension SelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = customCategories?.count ?? customSubcategories?.count ?? customOptions?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension SelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleItemSelection(index: indexPath.row)
    }
}

//MARK: - UISearchBarDelegate
extension SelectionView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearch(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
