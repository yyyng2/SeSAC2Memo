//
//  MemoView.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class MemoView: BaseView{

    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.rowHeight = 80
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.separatorColor = .systemGray2
        view.separatorInset.left = 0
        return view
    }()
    
    override func configure() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
  
}
