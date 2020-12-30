//
//  AChecklistViewController.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/30/20.
//

import UIKit
import UserNotifications

// 뷰에 대한 제어 <- 뷰는 자신에게 어떤 인터렉션이 이루어졌는지 감지 : 컨트롤러의 메소드를 호출 <- 그 로직은 다 컨트롤러에 ~
// 데이터 모델에 접근, 저장, 수정등이 가능
// MVC에서 거의 대부분 작업
class AChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
     //MARK: - ItemDetailVC 프로토콜 채택
         // 1). cancel
 func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
     navigationController?.popViewController(animated: true)
 }
         //2).  add
 func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
     checklist.items.append( item )
     checklist.sortItems()
     self.tableView.reloadData()
     navigationController?.popViewController(animated: true)
 }
         //3). edit <- 수정된 아이템의 인덱스 조회 <- 지정된 셀 찾기 <- 셀에 아이템 객체 동기화 <- 창 종료
 func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) { // finished item <- input
     checklist.sortItems()
     self.tableView.reloadData()
     navigationController?.popViewController(animated: true)
 }
    //MARK: - 객체 변수
    var checklist: Checklist! // 언팩킹 없이 사용 가능
    
    //MARK: - 뷰컨트롤러의 객체상의 변화에 반응
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
    }
    // MARK: - 테이블 뷰의 델리게이트
        // 1). 데이터 소스 메서드
            // 1>.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
            // 2>.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "item_in_a_list", for: indexPath )
        //
        let item = checklist.items[ indexPath.row ]
        //
        configureName(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        configureDueDate(for: cell, with: item)
        configureProgressBar(for: cell, with: item)
        //
        return cell
    }
        // 2). delegate 메서드
            // 1>.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let item = checklist.items[ indexPath.row ]
        item.checked.toggle()
        //
            // if user completes it, remove notification.
        if item.checked {
            item.removeNotification()
            // if it wasn't a mistake, re-register.
        }else{
            item.sheduleNotification()
        }
        //
        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell {
            configureCheckmark(for: cell, with: item)
        }
        // 선택 애니메이션 -> 해제 메소드
        tableView.deselectRow(at: indexPath, animated: true)
    }
            //2>.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(  identifier: "ItemDetailViewController"  ) as! ItemDetailViewController
        let checkListItem = self.checklist.items[indexPath.row]
        //
        controller.delegate = self
        controller.checklistItem = checkListItem
        //
        navigationController?.pushViewController(controller, animated: true)
        //
    }
    //
            // 3>.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [ indexPath ]
        tableView.deleteRows( at: indexPaths, with: .fade )
}
    // MARK: - 세그웨이 셋업
    override func prepare( for segue : UIStoryboardSegue, sender : Any? ){
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController // forced downcast from "UIViewController" -> specific
            controller.fromChecklist = self.checklist
            controller.delegate = self
        }
    }
    // MARK: - Helpler 메서드 : 아이템을 셀에 반영
        // 1).
    func configureCheckmark( for cell : UITableViewCell, with item : ChecklistItem ) {
        let label = cell.viewWithTag(1) as! UILabel
        label.text =  item.checked ?  "🐘" : ""
    }
        //2).
    func configureName( for cell : UITableViewCell, with item : ChecklistItem ) {
        let label = cell.viewWithTag(2) as! UILabel
        label.text = item.name
    }
        //3).
    func configureDueDate( for cell : UITableViewCell, with item : ChecklistItem ) {
            //
        let label = cell.viewWithTag(3) as! UILabel
            // Date -> componenets
        let calendar = Calendar( identifier: .gregorian )
        let components = calendar.dateComponents( [ .year, .month, .day, .hour, .minute ],  from: item.dueDate )
            // compute hour and /  ( am or pm )
        var phrase = "am"
        var hour = components.hour!
        if hour >= 12 {
            if hour == 12 { }
            else{
                hour = hour - 12
            }
            phrase = "pm"
        }
            // add "0" if minutes are 1 digit
        let minute = components.minute!
        var stringMinute = String(minute)
        if stringMinute.count == 1 {
            stringMinute = "0" + stringMinute
        }
            // assign label to that cell
        label.text = "~  \(components.month!)/\(components.day!)  \(hour):\(stringMinute)\(phrase)"
    }
        // 4).
    func configureProgressBar(for cell : UITableViewCell, with item: ChecklistItem){
        let progressView = cell.viewWithTag(4) as! UIProgressView
        let list = item.steps.list
        print(list)
        var progress : Float = 0.0
        if list.count != 0 {
            let countDone = list.filter{ $0.isDone == true }.count
            let count = list.count
            progress = Float(countDone) / Float( count )
        }
        progressView.setProgress(progress, animated: true)
    }
    
    //끝
}
 
