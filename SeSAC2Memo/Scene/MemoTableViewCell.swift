//
//  MemoTableViewCell.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class MemoTableViewCell: BaseTableViewCell{
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        return label
    }()
    let dateLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    let contentLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    override func configure() {
        backgroundColor = Constants.BaseColor.background
        [titleLabel, dateLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
            make.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
    }
}
