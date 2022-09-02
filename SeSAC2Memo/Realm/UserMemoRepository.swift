//
//  UserMemoRepository.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import Foundation

import RealmSwift

protocol UserMemoRepositoryType{
    func fetchFilter() -> Results<UserMemo>
    func fetchFilterPinned() -> Results<UserMemo>
    func fetchFilterUnPinned() -> Results<UserMemo>
//    func deleteFilterId(id: ObjectId)
    func fetch() -> Results<UserMemo>
    func updatePin(record: UserMemo)
    func deleteRecord(record: UserMemo)
    func addRecord(record: UserMemo)
}

class UserMemoRepository: UserMemoRepositoryType{
 
    
    
    //여러 곳에서 생성해도 하나의 Realm에 접근
    let localRealm = try! Realm() // struct
    
    func addRecord(record: UserMemo) {
        do{
            try localRealm.write{
                localRealm.add(record)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "regdate", ascending: true)
    }
    
    func fetchFilter() -> Results<UserMemo>{
        return localRealm.objects(UserMemo.self).filter("diaryTitle CONTAINS[c] 'a'")
    }
    
    func fetchFilterPinned() -> Results<UserMemo>{
        return localRealm.objects(UserMemo.self).filter("pin == true")
    }
    func fetchFilterUnPinned() -> Results<UserMemo>{
        return localRealm.objects(UserMemo.self).filter("pin == false")
    }
    
    func deleteById(id: ObjectId){
//        let task = localRealm.objects(UserMemo.self).filter("objectId == \(id)")
        let user = localRealm.object(ofType: UserMemo.self, forPrimaryKey: id)
        do{
            try localRealm.write{
                localRealm.delete(user!)
            }
        }catch let error {
            print(error)
        }
    }
    
    func updatePin(record: UserMemo) {
        do{
            try localRealm.write {
                //하나의 레코드에서 특정 컬럼 하나만 변경
                record.pin = !record.pin
            }
        } catch let error{
            print(error)
        }
        
    }
    
    func deleteRecord(record: UserMemo){
        do{
            try localRealm.write{
                localRealm.delete(record)
            }
        }catch let error {
            print(error)
        }
    }
    
}
