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
    
    let toolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barTintColor = Constants.BaseColor.foreground
        bar.backgroundColor = Constants.BaseColor.foreground
        return bar
    }()
    
    override func configure() {
        [tableView, toolBar].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        toolBar.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
  
}
