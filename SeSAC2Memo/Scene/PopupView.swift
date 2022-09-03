//
//  PopupView.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class PopupView: BaseView{
    
    let popView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "foregroundColor")
        view.layer.cornerRadius = 8
        return view
    }()
    
    let welcomeLabel: PopupLabel = {
       let label = PopupLabel()
        label.numberOfLines = 4
        label.textColor = UIColor(named: "fontColor")
        label.text = """
                    처음 오셨군요!
                    환영합니다. :)
                    당신만의 메모를 작성하고
                    관리해보세요!
                    """
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .orange
        button.setTitle("확인", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func configure() {
        backgroundColor = .clear
        [popView, welcomeLabel, doneButton].forEach {
            addSubview($0)
        }
    }
    override func setConstraints() {
        popView.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.8)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
            make.center.equalTo(safeAreaLayoutGuide)
        }
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(popView.snp.top).offset(16)
            make.left.equalTo(popView.snp.left).offset(20)
        }
        doneButton.snp.makeConstraints { make in
            
            make.left.equalTo(popView.snp.left).offset(20)
            make.right.equalTo(popView.snp.right).offset(-20)
            make.bottom.equalTo(popView.snp.bottom).offset(-8)
            make.height.equalTo(welcomeLabel.snp.height).multipliedBy(0.45)
        }
    }
}
