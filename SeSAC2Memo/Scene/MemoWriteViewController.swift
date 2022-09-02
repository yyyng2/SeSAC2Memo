//
//  MemoWriteViewController.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit
import RealmSwift

class MemoWriteViewController: BaseViewController{
    
    var memo: UserMemo?
    
    let repository = UserMemoRepository()
    
    var titleText = ""
    var contentText = ""
    
    var tasks: Results<UserMemo>! {
        didSet {
            let vc = MemoViewController()
            vc.mainView.tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    let mainView = MemoWriteView()
    
    override func loadView() {
        super.loadView()
        
        setNavigationUI()
        
        self.view = mainView
        
        mainView.memoTextView.delegate = self

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
        let content = mainView.memoTextView.text!
        let array = content.split(maxSplits: 1, omittingEmptySubsequences: false, whereSeparator: {$0 == "\n"})
        if array.count == 2 {
            titleText = String(array[0])
            contentText = String(array[1])
            let task = UserMemo(title: titleText, content: contentText, regdate: Date())
            repository.addRecord(record: task)
        } else {
            titleText = String(array[0])
            let task = UserMemo(title: titleText, content: "추가 텍스트 없음", regdate: Date())
            repository.addRecord(record: task)
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
       
    }
    @objc func shareButtonTapped(){
        let textToShare: String = "test."

        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
            // 성공했을 때 작업
           }  else  {
            // 실패했을 때 작업
           }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
        print("return")
         
      } else {
          titleText = String(text)
      }
      return true
    }


}
extension MemoWriteViewController: UITextViewDelegate{
    
}
