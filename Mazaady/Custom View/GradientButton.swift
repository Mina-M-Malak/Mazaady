//
//  GradientButton.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class GradientButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        let ititialColor = UIColor(red: 158.0/255.0, green: 2.0/255.0, blue: 87.0/255.0, alpha: 1.0)
        let endColor = UIColor(red: 210.0/255.0, green: 6.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        l.colors = [ititialColor.cgColor, endColor.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 8.0
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
