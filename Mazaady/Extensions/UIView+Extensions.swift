//
//  UIView+Extensions.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillSuperview(isSafeArea:Bool = true, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if isSafeArea {
            if #available(iOS 11.0, *) {
                anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding, size: size)
            } else {
                anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding, size: size)
            }
        } else {
            anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding, size: size)
        }
    }
    
    func setBorderColor(color: UIColor,width: CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func makeRoundedCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func makeRoundedCornersWith(radius: CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func setShadow(shadowColoe: UIColor,cornerRadius: CGFloat,shadowRadius: CGFloat,shadowOpacity: Float,width: CGFloat,height: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowColor = shadowColoe.cgColor
    }
}
