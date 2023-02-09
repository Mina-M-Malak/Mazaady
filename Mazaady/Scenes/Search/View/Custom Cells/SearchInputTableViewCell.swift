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
    private var property: Property?
    private var section: SearchSections?
    var reloadCellHeight: (()->())?
    var setText: ((_ value: String)->())?
    var didStartEditing: (()->())?
    private var selectedIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupUI() {
        searchInputTextField.setBorderColor(color: .lightGray, width: 0.5)
        searchInputTextField.makeRoundedCornersWith(radius: 8.0)
        
        searchInputTextField.inputView = UIView()
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
        self.property = nil
        otherTextField.isHidden = true
        arrowImageView.isHidden = false
        if let selectedCategoryindex = selectedCategoryindex {
            selectedIndex = selectedCategoryindex
            placeholderLabel.isHidden = false
            searchInputTextField.text = categories[selectedCategoryindex].name
        }
        else {
            selectedIndex = nil
            placeholderLabel.isHidden = true
            searchInputTextField.text = nil
        }
    }
    
    func setSubcategory(subcategories: [Subcategory],selectedSubcategoryindex: Int? = nil) {
        self.subcategories = subcategories
        categories?.removeAll()
        property = nil
        otherTextField.isHidden = true
        arrowImageView.isHidden = false
        if let selectedSubcategoryindex = selectedSubcategoryindex{
            selectedIndex = selectedSubcategoryindex
            placeholderLabel.isHidden = false
            searchInputTextField.text = subcategories[selectedSubcategoryindex].name
        }
        else{
            selectedIndex = nil
            placeholderLabel.isHidden = true
            searchInputTextField.text = nil
        }
    }
    
    func setOption(property: Property,selectedOptionIndex: Int? = nil,showOther: Bool) {
        categories?.removeAll()
        subcategories?.removeAll()
        searchInputTextField.placeholder =  property.name
        placeholderLabel.text = property.name
        self.property = property
        otherTextField.isHidden = !showOther
        arrowImageView.isHidden = property.options.isEmpty
        searchInputTextField.inputView = UIView()
        
        if property.options.isEmpty {
            searchInputTextField.inputView = nil
        }
        else if property.options.last?.id != 0 {
            self.property!.options.append(Option(id: 0, name: "Other", hasChild: false))
        }
        
        if let selectedOptionIndex = selectedOptionIndex {
            placeholderLabel.isHidden = false
            if selectedOptionIndex != -1 {
                searchInputTextField.text = property.options[selectedOptionIndex].name
                selectedIndex = selectedOptionIndex
            }
            else {
                otherTextField.text = property.otherValue
                searchInputTextField.text = (property.options.isEmpty) ? property.otherValue ?? self.property?.options.last?.name : self.property?.options.last?.name
                selectedIndex = property.options.count
            }
        }
        else if (property.otherValue?.isEmpty ?? true){
            selectedIndex = nil
            placeholderLabel.isHidden = true
            searchInputTextField.text = nil
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
            title = self.property?.options[row].name
        }
        pickerLabel.text = title
        pickerLabel.textColor = .black
        return pickerLabel
    }
    
    func textFieldEndEditing() {
        searchInputTextField.endEditing(true)
    }
    
    func setSearchInput(index: Int?,text: String?) {
        selectedIndex = index
        placeholderLabel.isHidden = false
        searchInputTextField.text = text
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
            return self.property?.options.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
}

//MARK: - UITextFieldDelegate
extension SearchInputTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderLabel.isHidden = false
        guard textField == searchInputTextField else { return }
        var defaultValue: String?
        switch section{
        case .category:
            if let selectedIndex = selectedIndex {
                defaultValue = categories?[selectedIndex].name
            }
        case .subcategory:
            if let selectedIndex = selectedIndex {
                defaultValue = subcategories?[selectedIndex].name
            }
        default:
            if (self.property?.options.isEmpty ?? true){
                defaultValue = self.property?.otherValue
            }
            else if let selectedIndex = selectedIndex {
                defaultValue = self.property?.options[selectedIndex].name
            }
        }
        textField.text = defaultValue
        didStartEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        placeholderLabel.isHidden = (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        guard let selectedIndex = selectedIndex , textField == searchInputTextField else {
            setText?(textField.text ?? "")
            return
        }
        if section == .option , !(self.property?.options.isEmpty ?? true) , self.property?.options[selectedIndex].id == 0 , otherTextField.isHidden{
            otherTextField.isHidden = false
            otherTextField.text = nil
            reloadCellHeight?()
        }
        else if !otherTextField.isHidden , (self.property?.options[selectedIndex].id != 0){
            otherTextField.isHidden = true
            reloadCellHeight?()
        }
        else if section == .option , (self.property?.options.isEmpty ?? true){
            setText?(textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
