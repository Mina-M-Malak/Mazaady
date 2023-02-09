//
//  BaseTextField.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

class BaseTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 30)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
