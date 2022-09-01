//
//  BaseView.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

import SnapKit

class BaseView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
    }
    func setConstraints(){
        
    }
}
