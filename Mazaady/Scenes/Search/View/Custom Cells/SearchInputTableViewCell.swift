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
            resetTextField()
        }
    }
    private var options: [Option]?
    private let dataPicker = UIPickerView()
    private var section: SearchViewController.Sections?
    var didSelectItem: ((_ index: Int)->())?
    var reloadCellHeight: (()->())?
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
        
        otherTextField.placeholder = "Spacify here"
    }
    
    private func resetTextField() {
        searchInputTextField.text = nil
        dataPicker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func setData(section: SearchViewController.Sections) {
        self.section = section
        searchInputTextField.placeholder =  section.placeholder
    }
    
    func setCategory(categories: [Category],selectedCategoryindex: Int? = nil) {
        self.categories = categories
        otherTextField.isHidden = true
        if let selectedCategoryindex = selectedCategoryindex{
            selectedIndex = selectedCategoryindex
            searchInputTextField.text = categories[selectedCategoryindex].name
        }
    }
    
    func setSubcategory(subcategories: [Subcategory],selectedSubcategoryindex: Int? = nil) {
        self.subcategories = subcategories
        otherTextField.isHidden = true
        if let selectedSubcategoryindex = selectedSubcategoryindex{
            selectedIndex = selectedSubcategoryindex
            searchInputTextField.text = subcategories[selectedSubcategoryindex].name
        }
    }
    
    func setOption(property: Property,selectedPropertyName: String? = nil,showOther: Bool) {
        searchInputTextField.placeholder =  property.name
        searchInputTextField.text = selectedPropertyName
        options = property.options
        otherTextField.isHidden = !showOther
        if property.options.isEmpty {
            searchInputTextField.inputView = nil
            arrowImageView.isHidden = true
        }
        else if property.options.last?.id != 0 {
            options?.append(Option(id: 0, name: "Other", slug: "Other", child: false))
        }
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
            title = options?[row].name
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
            return options?.count ?? 0
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
            searchInputTextField.text = options?[row].name ?? "Other"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return setPickerLabel(row: row)
    }
}

//MARK: - UITextFieldDelegate
extension SearchInputTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard (textField.text?.isEmpty ?? true) , let defaultValue = categories?.first?.name ?? subcategories?.first?.name ?? options?.first?.name else { return }
        textField.text = defaultValue
        selectedIndex = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let selectedIndex = selectedIndex else { return }
        didSelectItem?(selectedIndex)
        if section == .option , options?[selectedIndex].id == 0 , otherTextField.isHidden{
            otherTextField.isHidden = false
            reloadCellHeight?()
        }
        else if !otherTextField.isHidden {
            otherTextField.isHidden = true
            reloadCellHeight?()
        }
    }
}
