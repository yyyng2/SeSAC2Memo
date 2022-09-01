//
//  MemoViewController.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit
import RealmSwift

class MemoViewController: BaseViewController{
    //레포지토리 인스턴스 생성
    let repository = UserMemoRepository()
    //didSet
    var tasks: Results<UserMemo>! {
        didSet {
            mainView.tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    var titleCount = 0
    
    let searchBar: UISearchController = {
       let bar = UISearchController()
        bar.searchBar.placeholder = "검색"
        bar.searchBar.setValue("취소", forKey: "cancelButtonText")
        return bar
    }()
    
    let mainView = MemoView()
    
    override func loadView() {
        
        // 첫번째 앱 실행인지 확인
        if UserDefaultsHelper.standard.first == false {
            //마지막에 주석 해제할 것
            //UserDefaultsHelper.standard.first = true
            let viewController = PopupViewController()
            transition(viewController, transitionStyle: .present)
        }
        
        super.loadView()

        setNavigationUI()
        
        self.view = mainView
      
        searchBar.delegate = self
    }
    override func viewDidLoad() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchRealm()
        setNavigationUI()
    }
    
    @objc func writeItemTapped(){
        let vc = MemoWriteViewController()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        transition(vc, transitionStyle: .push)
    }
    
    @objc func backButtonTapped(){
        //백버튼탭 라지텍스트로 안돌아옴.. 완료버튼은 작동
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchRealm() {
        tasks = repository.fetch()
    }
    
    
    
    //네비게이션 라지타이틀 설정 , 서치바 추가
    override func setNavigationUI() {
        navigationBarAppearance.backgroundColor = Constants.BaseColor.background
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let writeItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeItemTapped))
        writeItem.tintColor = .orange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.navigationController?.toolbar.barTintColor = Constants.BaseColor.background
        self.navigationController?.toolbar.backgroundColor = Constants.BaseColor.background
        setToolbarItems([flexibleSpace, writeItem], animated: true)
        
        self.navigationItem.searchController = searchBar
 
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: #selector(backButtonTapped))
        backBarButtonItem.tintColor = .orange
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        fetchRealm()
        if tasks.count <= 0 {
            titleCount = 0
            self.navigationItem.title = "\(titleCount)개의 메모"
        } else {
            titleCount = tasks.count
            self.navigationItem.title = "\(titleCount)개의 메모"
        }
        
       
    }
    

    
    

}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = UIColor.clear
            header.textLabel?.textColor = .white
            header.textLabel?.font = .systemFont(ofSize: 20, weight: .black)
            header.sizeToFit()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "고정된 메모"
        } else {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 5
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0{
            cell.titleLabel.text = "test"
            cell.dateLabel.text = "2022.02.02 오후 02:02"
            cell.contentLabel.text = "asdfasdfasdfasfasdfasf"
        }
        cell.titleLabel.text = "test"
        
//        cell.setData(data: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            
            self.repository.updatePin(record: self.tasks[indexPath.row])

//            self.fetchRealm()
            
        }
        let image = tasks[indexPath.row].pin ? "pin.fill" : "pin"
        pin.image = UIImage(systemName: image)
        pin.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
            let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
                let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
                let okay = UIAlertAction(title: "삭제", style: .destructive) {_ in
                    //            self.repository.deleteRecord(record: self.tasks[indexPath.row])
                    //
                    //            self.fetchRealm()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(okay)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
            delete.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [delete])
      
    }
    
}
extension MemoViewController: UISearchControllerDelegate{
    
}
extension MemoViewController: UITabBarControllerDelegate{
    
}
