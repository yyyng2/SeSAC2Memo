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
        view.backgroundColor = .black
        view.textColor = .white
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
        addSubview(memoTextView)
        setKeyboardObserver()
    }
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
//            memoTextView.frame.height = keyboardHeight
        }
    }
    
    override func setConstraints() {

        memoTextView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
       
    }
}
