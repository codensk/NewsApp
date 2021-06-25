//
//  UIViewController+showAlert.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(button)
        
        present(alert, animated: true)
    }
}
