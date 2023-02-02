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
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private var categories: [Category]?
    private var subcategories: [Subcategory]?
    private var options: [Option]?
    private let dataPicker = UIPickerView()
    private var section: SearchSections?
    var didSelectItem: ((_ index: Int)->())?
    var reloadCellHeight: (()->())?
    var setText: ((_ value: String)->())?
    private var selectedIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupUI() {
        searchInputTextField.setBorderColor(color: .lightGray, width: 0.5)
        searchInputTextField.makeRoundedCornersWith(radius: 8.0)
        
        dataPicker.delegate = self
        dataPicker.dataSource = self
        
        searchInputTextField.inputView = dataPicker
        searchInputTextField.delegate = self
        otherTextField.delegate = self
        
        otherTextField.placeholder = "Spacify here"
        placeholderLabel.text = "Spacify here"
    }
    
    func setData(section: SearchSections) {
        setupUI()
        self.section = section
        searchInputTextField.placeholder =  section.placeholder
        placeholderLabel.text = section.placeholder
    }
    
    func setCategory(categories: [Category],selectedCategoryindex: Int? = nil) {
        self.categories = categories
        subcategories?.removeAll()
        options?.removeAll()
        otherTextField.isHidden = true
        arrowImageView.isHidden = false
        if let selectedCategoryindex = selectedCategoryindex {
            selectedIndex = selectedCategoryindex
            placeholderLabel.isHidden = false
            searchInputTextField.text = categories[selectedCategoryindex].name
            dataPicker.selectRow(selectedCategoryindex, inComponent: 0, animated: false)
        }
        else {
            selectedIndex = nil
            placeholderLabel.isHidden = true
            searchInputTextField.text = nil
            dataPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func setSubcategory(subcategories: [Subcategory],selectedSubcategoryindex: Int? = nil) {
        self.subcategories = subcategories
        categories?.removeAll()
        options?.removeAll()
        otherTextField.isHidden = true
        arrowImageView.isHidden = false
        if let selectedSubcategoryindex = selectedSubcategoryindex{
            selectedIndex = selectedSubcategoryindex
            placeholderLabel.isHidden = false
            searchInputTextField.text = subcategories[selectedSubcategoryindex].name
            dataPicker.selectRow(selectedSubcategoryindex, inComponent: 0, animated: false)
        }
        else{
            selectedIndex = nil
            placeholderLabel.isHidden = true
            searchInputTextField.text = nil
            dataPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func setOption(property: Property,selectedOptionIndex: Int? = nil,showOther: Bool) {
        categories?.removeAll()
        subcategories?.removeAll()
        searchInputTextField.placeholder =  property.name
        placeholderLabel.text = property.name
        options = property.options
        otherTextField.isHidden = !showOther
        arrowImageView.isHidden = property.options.isEmpty
        searchInputTextField.inputView = dataPicker
        
        if property.options.isEmpty {
            searchInputTextField.inputView = nil
        }
        else if property.options.last?.id != 0 {
            options?.append(Option(id: 0, name: "Other", slug: "Other", child: false))
        }
        
        if let selectedOptionIndex = selectedOptionIndex {
            placeholderLabel.isHidden = false
            if selectedOptionIndex != -1 {
                searchInputTextField.text = property.options[selectedOptionIndex].name
                selectedIndex = selectedOptionIndex
                dataPicker.selectRow(selectedOptionIndex, inComponent: 0, animated: false)
            }
            else {
                searchInputTextField.text = options?.last?.name
                selectedIndex = property.options.count
                dataPicker.selectRow(property.options.count, inComponent: 0, animated: false)
            }
        }
        else if (property.otherValue?.isEmpty ?? true){
            selectedIndex = nil
            placeholderLabel.isHidden = true
            searchInputTextField.text = nil
            dataPicker.selectRow(0, inComponent: 0, animated: false)
        }
        else{
            selectedIndex = nil
            placeholderLabel.isHidden = false
            searchInputTextField.text = property.otherValue
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
extension SearchInputTableViewCell: UIPickerViewDataSource {
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
extension SearchInputTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        placeholderLabel.isHidden = false
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
        placeholderLabel.isHidden = false
        guard textField == searchInputTextField else {
            textField.text = nil
            return
        }
        var defaultValue: String?
        switch section{
        case .category:
            defaultValue = (selectedIndex == nil) ? categories?.first?.name: categories?[selectedIndex!].name
        case .subcategory:
            defaultValue = (selectedIndex == nil) ? subcategories?.first?.name: subcategories?[selectedIndex!].name
        default:
            defaultValue = (selectedIndex == nil) ?(options?.first?.name) : options?[selectedIndex!].name
        }
        textField.text = defaultValue
        
        if (selectedIndex == nil){
            selectedIndex = 0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        placeholderLabel.isHidden = (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        guard let selectedIndex = selectedIndex , textField == searchInputTextField else {
            setText?(textField.text ?? "")
            return
        }
        didSelectItem?(selectedIndex)
        if section == .option , options?[selectedIndex].id == 0 , otherTextField.isHidden{
            otherTextField.isHidden = false
            otherTextField.text = nil
            reloadCellHeight?()
        }
        else if !otherTextField.isHidden {
            otherTextField.isHidden = true
            reloadCellHeight?()
        }
    }
}
