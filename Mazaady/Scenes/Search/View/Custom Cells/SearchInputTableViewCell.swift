//
//  SearchInputTableViewCell.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

class SearchInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchInputTextField: UITextField!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    private var categories: [Category]?
    private var subcategories: [Subcategory]?{
        didSet{
            searchInputTextField.text = nil
            dataPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    private let dataPicker = UIPickerView()
    private var section: SearchViewController.Sections?
    var didSelectItem: ((_ index: Int)->())?
    private var selectedIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        searchInputTextField.setBorderColor(color: .lightGray, width: 0.5)
        searchInputTextField.makeRoundedCornersWith(radius: 8.0)
        
        dataPicker.delegate = self
        dataPicker.dataSource = self
        
        searchInputTextField.inputView = dataPicker
        searchInputTextField.delegate = self
    }
    
    func setData(section: SearchViewController.Sections) {
        self.section = section
        searchInputTextField.placeholder =  section.placeholder
    }
    
    func setCategory(categories: [Category],selectedCategoryindex: Int? = nil) {
        self.categories = categories
        if let selectedCategoryindex = selectedCategoryindex{
            searchInputTextField.text = categories[selectedCategoryindex].name
        }
    }
    
    func setSubcategory(subcategories: [Subcategory],selectedSubcategoryindex: Int? = nil) {
        self.subcategories = subcategories
        if let selectedSubcategoryindex = selectedSubcategoryindex{
            searchInputTextField.text = subcategories[selectedSubcategoryindex].name
        }
    }
    
    func setOption(option: Property) {
        searchInputTextField.placeholder =  option.name
    }
    
    private func setPickerLabel(row: Int) -> UILabel {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        pickerLabel.textAlignment = .center
        var title: String? = ""
        switch section {
        case .category:
            title = categories?[row].name
        case .subcategory:
            title = subcategories?[row].name
        default:
            break
        }
        pickerLabel.text = title
        pickerLabel.textColor = .black
        return pickerLabel
    }
}

//MARK: - UIPickerViewDataSource
extension SearchInputTableViewCell: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch section {
        case .category:
            return categories?.count ?? 0
        case .subcategory:
            return subcategories?.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
}

//MARK: - UIPickerViewDelegate
extension SearchInputTableViewCell: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        switch section {
        case .category:
            searchInputTextField.text = categories?[row].name
        case .subcategory:
            searchInputTextField.text = subcategories?[row].name
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return setPickerLabel(row: row)
    }
}

//MARK: - UITextFieldDelegate
extension SearchInputTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard (textField.text?.isEmpty ?? true) , let defaultValue = categories?.first?.name ?? subcategories?.first?.name else { return }
        textField.text = defaultValue
        selectedIndex = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let selectedIndex = selectedIndex else { return }
        didSelectItem?(selectedIndex)
    }
}
