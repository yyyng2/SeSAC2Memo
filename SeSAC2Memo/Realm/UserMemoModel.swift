//
//  UserMemoModel.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import Foundation

import RealmSwift
import UIKit

class UserMemo: Object{
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var allText: String
    @Persisted var regdate = Date()
    @Persisted var pin: Bool
    
    convenience init(allText: String, title: String, content: String?, regdate: Date) {
        self.init()
        self.title = title
        self.allText = allText
        self.content = content
        self.regdate = regdate
        self.pin = false
    }
}
