//
//  UIView+Extensions.swift
//  Mazaady
//
//  Created by Mina Malak on 01/02/2023.
//

import UIKit

extension UIView {
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
