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
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    let dateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray3
        return label
    }()
    let contentLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray3
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
            make.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(0.7)
            make.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.left.equalTo(dateLabel.snp.right).offset(8)
            make.right.equalTo(safeAreaLayoutGuide).offset(4)
        }
    }
    
}
