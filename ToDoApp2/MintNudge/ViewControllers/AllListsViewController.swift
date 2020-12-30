//
//  AllListsViewController.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/29/20.
//

import UIKit

class AllListsViewController: UITableViewController, AddListViewControllerDelegate, UINavigationControllerDelegate  {
    // MARK: - AddListVC 델리게이트 구현
    func addListViewControllerDidCancel(_ controller: AddListViewController) {
        navigationController?.popViewController(animated: true)
    }
    func addListViewController(_ controller: AddListViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append( checklist )
        dataModel.sortChecklists()
        self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    func addListViewController(_ controller: AddListViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    // MARK: - 속성
        // 데이터 모델에 대한 레퍼런스 떨궈 주는 것. 하지만 이전 뷰 컨트롤러에 대한 레퍼런스는 없다.
    var dataModel : DataModel!
    // MARK: -  뷰 컨트롤러 전환 시점에 반응하는 메서드
        // 1). 뷰 객체에 메모리 할당
    override func viewDidLoad() {
        super.viewDidLoad()
        // 네비게이션 컨트롤러의 Bar를 기본적으로 크게 설정 -> 이후 자식 뷰들
        navigationController?.navigationBar.prefersLargeTitles = true
            // The nearest ancestor in the view controller hierarchy that is a navigation controller.
        }
        // 2). 네비게이션에서 뷰의 등장
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 앱 시작시에는 바로 발동되지 않는다.
        if viewController === self {
            dataModel.lastVisitedScreen = -1 // 세터 -> 자동으로 데이터까지 업데이트 되도록
        }
        // 하지만, 정렬하고 -> 디스플레이 한다.
        dataModel.sortChecklists()
        tableView.reloadData()
    }
        // 3). 뷰가 최상위에 등장한 후에 ~
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.lastVisitedScreen // getter 발동
        // -1이 아니고, 리스트가 존재하지 않는 게 아니라면 이동
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index] // 인덱스 받고 -> 그 체크리스트를 기준으로 세그웨이 실행
            performSegue( withIdentifier: "ShowChecklist", sender: checklist )
        }
    }
    // MARK: -  테이블뷰 델리게이트 - 데이터 소스 객체 전담
        // 1).
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        //2).
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists .count
    }
        //3).
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // <1>.
        let cell = tableView.dequeueReusableCell(withIdentifier: "a_checklist_cell", for: indexPath)
            // <2>. configure cell <- checklist
        let checklist = dataModel.lists[ indexPath.row ]
        cell.textLabel?.text = "\(checklist.name)"
        cell.imageView!.image = UIImage(named: "\(checklist.iconName)")
        let phrase : String
        if checklist.items.isEmpty {
            phrase = "비어 있음"
        }else if checklist.countUndone() == 0 {
            phrase = "모두 완료🔥"
        }else{
            phrase = "\(checklist.countUndone())개 남음"
        }
        cell.detailTextLabel?.text = phrase
                //<3>. 리턴
        return cell
    }
        //4).
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController( identifier: "AddListViewController"  ) as! AddListViewController
        // set up
        let checklist = dataModel.lists[ indexPath.row ]
        controller.delegate = self
        controller.checklistToEdit = checklist
        // push
        navigationController?.pushViewController(controller, animated: true)
    }
        //5).
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath){
        let checklist = dataModel.lists[ indexPath.row ]
        let userDefaults = UserDefaults.standard
        userDefaults.set( indexPath.row, forKey: "lastVisitedScreen" )
        // manual segue != button, accessory (automatic) : prepare를 통해 선택한 곳의 객체를 inject할 수 있다.
        performSegue( withIdentifier: "ShowChecklist", sender: checklist )
    }
        //6).
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [ indexPath ]
        tableView.deleteRows( at: indexPaths, with: .fade )
    }
    // MARK: - 세그웨이 : 세그웨이 실행전 셋업들
        // 1).
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // button -> auto perform segue !!
        if segue.identifier == "add_list"{
            let controller = segue.destination as! AddListViewController
            controller.delegate = self
        }
        else if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! AChecklistViewController
            controller.checklist = sender as? Checklist // ( 닐 또는 체크리스트 객체 ) 옵셔널 객체
        }
    }
    
    // 끝
}
    
