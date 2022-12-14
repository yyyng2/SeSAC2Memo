//
//  MemoWriteViewController.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit
import RealmSwift

final class MemoWriteViewController: BaseViewController{
    
    var edit = false
    
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
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        setNavigationUI()
        
        self.view = mainView
        
        mainView.memoTextView.delegate = self
        
        if edit == true{
            guard let title = memo?.title else { return }
            guard let content = memo?.content else { return }
            mainView.memoTextView.text = "\(title)\n\(content)"
        }
        
        swipeRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveFunction()
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneButtonTapped))
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        
    }
    
    @objc func doneButtonTapped(){
        print(#function)
        saveFunction()
    }
    
    func saveFunction(){
        print(#function)
        if edit == true {
            let id = memo?.objectId
            let content = mainView.memoTextView.text!
            let array = content.split(maxSplits: 1, omittingEmptySubsequences: false, whereSeparator: {$0 == "\n"})
            if array.count == 2 {
                titleText = String(array[0])
                contentText = String(array[1])
                let task = UserMemo(title: titleText, content: contentText, regdate: Date())
                repository.updateRecord(id: id!, record: task)
            } else {
                titleText = String(array[0])
                let task = UserMemo(title: titleText, content: "", regdate: Date())
                repository.updateRecord(id: id!, record: task)
            }
        } else {
            let content = mainView.memoTextView.text!
            let array = content.split(maxSplits: 1, omittingEmptySubsequences: false, whereSeparator: {$0 == "\n"})
            if array.count == 2 {
                titleText = String(array[0])
                contentText = String(array[1])
                let task = UserMemo(title: titleText, content: contentText, regdate: Date())
                repository.addRecord(record: task)
            } else {
                titleText = String(array[0])
                let task = UserMemo(title: titleText, content: "", regdate: Date())
                repository.addRecord(record: task)
            }
        }
        
        repository.deleteEmptyRecord()
        
        edit = false
        let vc = MemoViewController()
        vc.fetchRealm()
        vc.searchStatus = false
        vc.searchKeyword = ""
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func swipeRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
                case UISwipeGestureRecognizer.Direction.right:
                self.saveFunction()
                self.dismiss(animated: true)
            default: break
                 }
            }
    }


    
    @objc func shareButtonTapped(){
        let trimString = mainView.memoTextView.text!.filter {!"\n".contains($0)}
        let textToShare: String = trimString

        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
            // 성공했을 때 작업
                self.showAlert(title: "", message: "전달에 성공했습니다.", buttonTitle: "확인")
           }  else  {
            // 실패했을 때 작업
               self.showAlert(title: "", message: "전달에 실패했습니다.", buttonTitle: "확인")
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
