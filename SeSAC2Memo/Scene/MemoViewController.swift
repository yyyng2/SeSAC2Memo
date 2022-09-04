//
//  MemoViewController.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit
import RealmSwift

final class MemoViewController: BaseViewController{
    //레포지토리 인스턴스 생성
    let repository = UserMemoRepository()
    //didSet
    var tasks: Results<UserMemo>! {
        didSet {
            mainView.tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    var pinned: Results<UserMemo>!{
        didSet {
            mainView.tableView.reloadData()
            print("Tasks Changed")
        }
    }
    var unPinned: Results<UserMemo>!{
        didSet {
            mainView.tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    var searchResults: Results<UserMemo>!{
        didSet {
            mainView.tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    let dateFormatter = DateFormatter()
    
    var searchKeyword = ""
    
    var searchStatus = false
    
    func format(for number: Int) -> String{
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: number)!
    }
    
    var titleCount = 0
    
    let searchBar: UISearchController = {
       let bar = UISearchController()
        bar.searchBar.placeholder = "검색"
        bar.searchBar.setValue("취소", forKey: "cancelButtonText")
        bar.searchBar.tintColor = .orange
        return bar
    }()
    
    let mainView = MemoView()
    
    override func loadView() {
        
        // 첫번째 앱 실행인지 확인
        if UserDefaultsHelper.standard.first == false {
            //마지막에 주석 해제할 것
            UserDefaultsHelper.standard.first = true
            let viewController = PopupViewController()
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true)
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
        mainView.tableView.keyboardDismissMode = .onDrag
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchRealm()
        setNavigationUI()
        searchKeyword = ""
    }
    
    @objc func writeItemTapped(){
        let vc = MemoWriteViewController()
        vc.edit = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        transition(vc, transitionStyle: .push)
    }
    
    @objc func backButtonTapped(){
        //백버튼탭눌러서 팝 할시 메인화면 라지타이틀로 안돌아옴.. 완료버튼은 메인화면 라지타이틀정상 작동
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchRealm() {
        tasks = repository.fetch()
        pinned = repository.fetchFilterPinned()
        unPinned = repository.fetchFilterUnPinned()
        mainView.tableView.reloadData()
    }
    
    func fetchResults(results: Results<UserMemo>){

        searchResults = results
        fetchRealm()
       
    }
    
    //날짜별 포맷
    func dateCal(date: Date, task: Results<UserMemo>, tag: IndexPath, label: UILabel){
        let distance = Calendar.current.dateComponents([.hour], from: task[tag.row].regdate, to: Date()).hour
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if distance! < 24{
            dateFormatter.dateFormat = "a hh:mm"
            let date = dateFormatter.string(from: task[tag.row].regdate)
            label.text = "\(date)"
        } else if distance! < 168 {
            dateFormatter.dateFormat = "EEEE"
            let date = dateFormatter.string(from: task[tag.row].regdate)
            label.text = "\(date)"
        } else {
            dateFormatter.dateFormat = "yyyy. MM. dd a hh:mm"
            let date = dateFormatter.string(from: task[tag.row].regdate)
            label.text = "\(date)"
        }
    }
    
    
    
    //네비게이션 라지타이틀 설정 , 서치바 추가
    override func setNavigationUI() {
        navigationBarAppearance.backgroundColor = Constants.BaseColor.foreground
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "fontColor")!]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "fontColor")!]
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        //툴바
        let writeItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeItemTapped))
        writeItem.tintColor = .orange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([flexibleSpace, writeItem], animated: true)
        
        self.navigationItem.searchController = searchBar
        self.navigationItem.searchController?.searchResultsUpdater = self
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
 
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
            let stringText = self.format(for: titleCount)
            self.navigationItem.title = "\(stringText)개의 메모"
        }
        
       
    }
    
    //검색키워드 컬러 변경
    func searchKeywordChangeColor(string: String, label: UILabel){
        let attributeString = NSMutableAttributedString(string: string)
        var textFirstIndex: Int = 0
        if let textFirstRange = string.range(of: "\(searchKeyword)", options: .caseInsensitive) {
            textFirstIndex = string.distance(from: string.startIndex, to: textFirstRange.lowerBound)
            attributeString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: textFirstIndex, length: searchKeyword.count))
            attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: label.font.pointSize), range: NSRange(location: textFirstIndex, length: searchKeyword.count))
            label.attributedText = attributeString
                 
        }
    }
    

}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchStatus == false {
            return 2
        }
        return 1

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = UIColor.clear
            header.textLabel?.textColor = UIColor(named: "fontColor")
            header.textLabel?.font = .systemFont(ofSize: 20, weight: .black)
            header.sizeToFit()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchStatus == false{
            if section == 0{
                return pinned.count <= 0 ? "" : "고정된 메모"
            } else {
                return unPinned.count <= 0 ? "" : "메모"
            }
        }
        let count = searchResults == nil ? 0 : searchResults.count
        return "\(count)개 찾음"
    }
            
            
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchStatus == false {
            if section == 0{
                return pinned.count <= 0 ? 0 : pinned.count
            } else {
                return unPinned.count <= 0 ? 0 : unPinned.count
            }
        }
        let count = searchResults == nil ? 0 : searchResults.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor(named: "foregroundColor")

        if searchStatus == false {
            if indexPath.section == 0{
                if pinned.count > 0 {
                    let trimString = pinned![indexPath.row].content!.filter {!"\n".contains($0)}
                    cell.titleLabel.text = pinned![indexPath.row].title
                    dateCal(date: Date(), task: pinned, tag: indexPath, label: cell.dateLabel)
//                    cell.dateLabel.text = "\(pinned![indexPath.row].regdate)"
                    cell.contentLabel.text = trimString
                }
            } else {
                if unPinned.count > 0{
                    let trimString = unPinned![indexPath.row].content!.filter {!"\n".contains($0)}
                    cell.titleLabel.text = unPinned[indexPath.row].title
                    dateCal(date: Date(), task: unPinned, tag: indexPath, label: cell.dateLabel)
//                    cell.dateLabel.text = "\(unPinned[indexPath.row].regdate)"
                    cell.contentLabel.text = trimString
                }
            }
            
            return cell
        }
    
        let string = searchResults[indexPath.row].title
        let trimString = searchResults[indexPath.row].content!.filter {!"\n".contains($0)}
      
     
        searchKeywordChangeColor(string: string, label: cell.titleLabel)
        searchKeywordChangeColor(string: trimString, label: cell.contentLabel)
        
        dateCal(date: Date(), task: searchResults, tag: indexPath, label: cell.dateLabel)
        
//        cell.titleLabel.text = searchResults[indexPath.row].title
//        cell.dateLabel.text = "\(searchResults[indexPath.row].regdate)"
//        cell.contentLabel.text = trimString
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MemoWriteViewController()
        vc.edit = true
        if searchStatus == false{
            if indexPath.section == 0 {
                vc.memo = pinned[indexPath.row]
                transition(vc, transitionStyle: .push)
            } else {
                vc.memo = unPinned[indexPath.row]
                transition(vc, transitionStyle: .push)
            }
        } else {
            let backBarButtonItem = UIBarButtonItem(title: "검색", style: .plain, target: self, action: #selector(backButtonTapped))
            backBarButtonItem.tintColor = .orange
            self.navigationItem.backBarButtonItem = backBarButtonItem
            vc.memo = searchResults[indexPath.row]
            transition(vc, transitionStyle: .push)
        }
     
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
    }
    

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.searchStatus == false {
            
            if indexPath.section == 0 {
                let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                    self.repository.updatePin(record: self.pinned[indexPath.row])
                    self.fetchRealm()
                }
                
                let image = self.pinned[indexPath.row].pin ? "pin.fill" : "pin"
                pin.image = UIImage(systemName: image)
                pin.backgroundColor = .orange
                
                return UISwipeActionsConfiguration(actions: [pin])
                
            } else {
                let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                    if self.pinned.count < 5 {
                        self.repository.updatePin(record: self.unPinned[indexPath.row])
                        self.fetchRealm()
                    } else {
                        self.showAlert(title: "!", message: "고정 메모는 5개를 넘을 수 없습니다.", buttonTitle: "확인")
                        return
                    }
                    
                    self.fetchRealm()
                }
                let image = self.unPinned[indexPath.row].pin ? "pin.fill" : "pin"
                pin.image = UIImage(systemName: image)
                pin.backgroundColor = .orange
                
                return UISwipeActionsConfiguration(actions: [pin])
                
            }
            
            
        } else {
            let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                if self.pinned.count < 5 {
                    self.repository.updatePin(record: self.searchResults[indexPath.row])
                    self.fetchRealm()
                } else {
                    self.showAlert(title: "!", message: "고정 메모는 5개를 넘을 수 없습니다.", buttonTitle: "확인")
                    return
                }
                
                self.fetchRealm()
                
            }
            
            let image = self.searchResults[indexPath.row].pin ? "pin.fill" : "pin"
            pin.image = UIImage(systemName: image)
            pin.backgroundColor = .orange
            
            return UISwipeActionsConfiguration(actions: [pin])
            
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandler in
            
            let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
            
            let okay = UIAlertAction(title: "삭제", style: .destructive) {_ in

                if self.searchStatus == false {
                    if indexPath.section == 0 {
                        let task = self.pinned![indexPath.row].objectId
                        self.repository.deleteById(id: task)
                        self.fetchRealm()
                    } else {
                        let task = self.unPinned![indexPath.row].objectId
                        self.repository.deleteById(id: task)
                        self.fetchRealm()
                    }
                } else {
                    let task = self.searchResults[indexPath.row].objectId
                    self.repository.deleteById(id: task)
                    self.fetchRealm()
                }
 
            

               
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
    func willPresentSearchController(_ searchController: UISearchController) {

    }

    func willDismissSearchController(_ searchController: UISearchController) {
        searchStatus = false
        searchKeyword = ""
        fetchRealm()
        mainView.tableView.reloadData()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        searchStatus = false
        searchKeyword = ""
        fetchRealm()
        mainView.tableView.reloadData()
    }

    
}
extension MemoViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text else {
            return
        }
        
        searchStatus = true
        fetchResults(results: repository.fetchFilter(text: text))
        searchKeyword = text
        
        
        print(searchResults.count)
        fetchRealm()
        mainView.tableView.reloadData()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // TextField 비활성화
            return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchStatus = false
        searchKeyword = ""
        fetchRealm()
        mainView.tableView.reloadData()

        
    }

}

extension MemoViewController: UITabBarControllerDelegate{
    
}

