//
//  MemoWriteViewController.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class MemoWriteViewController: BaseViewController{
    let mainView = MemoWriteView()
    
    override func loadView() {
        super.loadView()
        
        setNavigationUI()
        
 
        
        self.view = mainView
    }
    
    
    
    override func setNavigationUI() {
        navigationBarAppearance.backgroundColor = Constants.BaseColor.background
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            
    
        let doneButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        let shareButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        doneButtonItem.tintColor = .orange
        shareButtonItem.tintColor = .orange
        self.navigationItem.rightBarButtonItems = [doneButtonItem, shareButtonItem]
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        
    }
    
    @objc func doneButtonTapped(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
       
    }
    @objc func shareButtonTapped(){
        
    }


}
