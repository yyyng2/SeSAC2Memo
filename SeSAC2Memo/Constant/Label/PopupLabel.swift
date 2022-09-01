//
//  PopupLabel.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class PopupLabel: UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        backgroundColor = .clear
        textColor = .white
        font = .boldSystemFont(ofSize: 24)
    }
}
