//
//  UIViewController+Extension.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/09/01.
//

import UIKit

extension UIViewController{
    func showAlert(title: String, message: String, buttonTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
