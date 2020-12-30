//
//  ItemDetailViewController.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/30/20.
//

import UIKit
import UserNotifications

// MARK: - 아이템 세부사항 뷰컨트롤러 프로토콜 정의
protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller : ItemDetailViewController)
    func itemDetailViewController(_ controller : ItemDetailViewController, didFinishAdding item : ChecklistItem )
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

// MARK: - 아이템 티테일 뷰 컨트롤러 정의
class ItemDetailViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TenGageViewControllerDelegate {

    // UI 요소들을 체크리스트 객체에 반영
    func tenGageViewControllerDidDismiss(stepsList : [Step]) {
        self.stepsList = stepsList
    }
    func tenGageViewControllerDidDismissForEditing() {
        
    }
    // MARK:- 피커뷰 데이터 소스
        // 1). data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerviewData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerviewData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerviewData[component][row]
    }
    
        // 2). delegate
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        // 임시 저장소에 저장
//        self.userPickedNumOfSteps = Int( pickerviewData[component][row] )!
//            // 1) add일 경우 -> 갯수 만큼 빈 객체의 step들을 임시 스텝 저장소에 지정
//
//            // 2). edit일 경우 ->  갯수가 늘어난 만큼 더하고, 줄어든 만큼 끝에서 부터 자르기
//    }
    
    // MARK: - 속성
    weak var checklistItem : ChecklistItem? = nil
    weak var fromChecklist : Checklist? = nil
    weak var delegate : ItemDetailViewControllerDelegate?
    @IBOutlet weak var alarmButton: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var stepNumberPicker: UIPickerView!
    var pickerviewData = [ (0...15).map{ String($0) }  ]
    // add 상황을 위한 변수( 아무것도 없는 것으로 초기화 )
    var stepsList : [Step] = []
    
    //MARK: -메서드
        // 뷰 관련
            // 1). 뷰 컨트롤러 객체 로딩시
    override func viewDidLoad() {
        super.viewDidLoad()
        // pickerview delegate registration
        stepNumberPicker.delegate = self
        stepNumberPicker.dataSource = self
        // 1). edit
        if let checklistItem = checklistItem {
            title = "\(checklistItem.name) 계획 수정"
            self.itemName.text! = checklistItem.name
            self.alarmButton.isOn = checklistItem.shouldRemind
            self.datePicker.date = checklistItem.dueDate
            // 기본값으로 0 설정 후 애니메이션 주기
            self.stepNumberPicker.selectRow(0, inComponent: 0, animated: false)  // 0으로 시작해서 -> 1개 이상있을
        }
        // 2). add
        else{
                // 1>. 타이틀 설정
            title = "\(self.fromChecklist!.name)에 계획 추가"
                // 2>. 버튼 비활성화
            doneBarButton.isEnabled = false
            self.alarmButton.isOn = false
                // 3>. 데이터 피커에 <- 현재 시간 +1
            var hourComponent   =  DateComponents()
            hourComponent.hour  = 1
            let theCalendar     = Calendar.current
            let nextDate = theCalendar.date( byAdding: hourComponent, to: Date() )
            self.datePicker.date = nextDate!
                // 4>. 기본값으로 0 설정
            self.stepNumberPicker.selectRow(0, inComponent: 0, animated: false)
            stepsList = []
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
        // 2). 뷰가 등장하고 나서 UI 동기화
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 편집 시에는 객체의 데이터 상태에 맞게 애니메이션
        if let checklistItem = checklistItem {
                self.stepNumberPicker.selectRow( checklistItem.steps.list.count, inComponent: 0, animated: true )
        }
    }
    
    //MARK: - 뷰 컨트롤러 변화에 반응
        // 2). 뷰가 처음으로 등장할 때
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 편집뷰에서는 텍스트가 퍼스트 리스폰더가 되지 않게 -> 다른 요소들도 똑같은 확률로 수정하러 왔을 수 있다.
        if checklistItem == nil {
            itemName.becomeFirstResponder()
        }
    }
    //MARK: - 테이블뷰 델리게이트
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // prepare 하고, perform segue
        if let checklistItem = checklistItem {
            //
            let userSetNum = stepNumberPicker.selectedRow(inComponent: 0)
            //
            if checklistItem.steps.list.count  > userSetNum {
                let diff =  checklistItem.steps.list.count - userSetNum
                for _ in (1...diff){
                    checklistItem.steps.list.removeLast() // pop steps
                }
            }else if checklistItem.steps.list.count < userSetNum {
                let diff = userSetNum - checklistItem.steps.list.count
                for _ in (1...diff)
                {
                    checklistItem.steps.list.append( Step() ) // 빈 객체 어펜드
                }
            }
            performSegue(withIdentifier: "define_steps", sender: checklistItem ) // 체크리스트 아이템 객체 가져가기 <- 아예 이 객체를 변형시키기
        }
        // if it's adding
        else {
            //
            let selectedNumber = stepNumberPicker.selectedRow(inComponent: 0)
            if selectedNumber > stepsList.count {
                // 보충
                for _ in (1...selectedNumber-stepsList.count){
                    stepsList.append( Step() )
                }
            }
            else if selectedNumber < stepsList.count {
                for _ in ( 1...( stepsList.count - selectedNumber) ){
                    stepsList.removeLast()
                }
            }
            //
            performSegue(withIdentifier: "define_steps", sender: nil)
        }
        
    }
    //MARK: - Button Action 메서드
        // 버튼 액션 관련
            // 1). 완료
    @IBAction func done(){
        
        if let checklistItem = checklistItem {
            
            checklistItem.shouldRemind = self.alarmButton.isOn
            checklistItem.dueDate = datePicker.date
            checklistItem.name = self.itemName.text!
            checklistItem.sheduleNotification()
            //
            // configure changes after user touched  ( i ) button
            let lastUpdatedPickerNum =  stepNumberPicker.selectedRow(inComponent: 0)
            //
            if lastUpdatedPickerNum > checklistItem.steps.list.count {
                for _ in ( 1...(lastUpdatedPickerNum-checklistItem.steps.list.count) ){
                    checklistItem.steps.list.append( Step() )
                }
            }
            else if lastUpdatedPickerNum < checklistItem.steps.list.count {
                for _ in ( 1...( checklistItem.steps.list.count - lastUpdatedPickerNum) ){
                    checklistItem.steps.list.removeLast()
                }
            }
            //
            delegate?.itemDetailViewController( self, didFinishEditing: checklistItem )
        }
        else {
            
            let checklistItem = ChecklistItem()
            checklistItem.shouldRemind = self.alarmButton.isOn
            checklistItem.dueDate = datePicker.date
            checklistItem.name = self.itemName.text!
            checklistItem.sheduleNotification()
            // configure changes after user touched  ( i ) button
            let lastUpdatedPickerNum =  stepNumberPicker.selectedRow(inComponent: 0)
            //
            if lastUpdatedPickerNum > self.stepsList.count {
                for _ in ( 1...(lastUpdatedPickerNum-stepsList.count) ){
                    self.stepsList.append( Step() )
                }
            }
            else if lastUpdatedPickerNum < stepsList.count {
                for _ in ( 1...( stepsList.count - lastUpdatedPickerNum) ){
                    self.stepsList.removeLast()
                }
            }
            //
            checklistItem.steps.list = self.stepsList
            //
            delegate?.itemDetailViewController(self, didFinishAdding: checklistItem)
        }
    }
        // 2). 취소
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
        // 3). 알림 스위치
@IBAction func shouldRemindToggled( _ switchControl: UISwitch ){
itemName.resignFirstResponder()
if switchControl.isOn {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization( options: [ .alert, .sound ]  ){  _,  _ in
        }
    }
}
    //MARK: - 텍스트 필드 델리게이트
        // 1).
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range( range, in: oldText )!
        let newText = oldText.replacingCharacters( in: stringRange, with: string )
        self.doneBarButton.isEnabled = ( !newText.isEmpty )
        return true
    }
        // 2)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.itemName {
            if textField.text!.count != 0{
                done()
            }
        }
        return true
    }
        //3).
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    // MARK: - 세그웨이 : 세그웨이 실행전 셋업들
        // 1).
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "define_steps"{
            
            if checklistItem != nil {
                let controller = segue.destination as! TenGageViewController
                controller.checklistItem = sender as? ChecklistItem // 아이템 페러런스 넣어준다.
                controller.delegate = self
            }
            
            else {
                let controller = segue.destination as! TenGageViewController
                controller.stepsList = self.stepsList // array of references
                controller.delegate = self
            }
        }
    }
    
    // 끝
}
