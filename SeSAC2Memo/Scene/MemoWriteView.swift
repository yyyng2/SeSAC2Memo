//
//  MemoWriteView.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

class MemoWriteView: BaseView{
    
    let memoTextView : UITextView = {
       let view = UITextView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.textColor = UIColor(named: "fontColor")
        view.becomeFirstResponder()
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configure() {
        backgroundColor = UIColor(named: "backgroundColor")
        addSubview(memoTextView)
        setKeyboardObserver()
    }
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //키보드 높이만큼...how?
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

        }
    }
    
    override func setConstraints() {

        memoTextView.snp.makeConstraints { make in
            make.top.left.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.55)
        }

       
    }
    
  
    
   
}
