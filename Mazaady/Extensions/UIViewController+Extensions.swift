//
//  UIViewController+Extensions.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

extension UIViewController{
    
    func showAlert(title: String? = "",message : String? = nil ,handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
                handler?(action)
            }
        }))
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
}
