//
//  PopupViewController.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

final class PopupViewController: BaseViewController{
    let mainView = PopupView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
        view.backgroundColor = .clear
    }
    
    override func configureUI() {
        mainView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc func doneButtonTapped(){
        dismiss(animated: true)
    }
}
