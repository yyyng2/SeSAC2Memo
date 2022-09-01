//
//  ReusableProtocol.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

protocol ReusableViewProtocol: AnyObject{
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol{
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol{
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
