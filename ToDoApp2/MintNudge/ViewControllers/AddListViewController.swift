//
//  AddListViewController.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/30/20.
//

import UIKit

// MARK: - 이 뷰 컨트롤러의 델리게이트에 대한 프로토콜
protocol AddListViewControllerDelegate : class { // we want this proto. to be adopted only by class objs.
    func addListViewControllerDidCancel(_ controller : AddListViewController)
    func addListViewController(_ controller : AddListViewController, didFinishAdding checklist : Checklist )
    func addListViewController(_ controller: AddListViewController, didFinishEditing checklist: Checklist)
}

class AddListViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    // MARK: - 아이콘 픽커 델리게이트
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        self.iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    // MARK: - 객체 변수
    weak var delegate : AddListViewControllerDelegate?
    weak var checklistToEdit : Checklist? // 이걸 안 받을 수도 있다.
    var iconName = "No Icon"
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    // MARK: - 뷰 컨트롤러의 변화에 따른 반응
        // 1).
    override func viewDidLoad() {
        super.viewDidLoad()
        // 텍스트 필드 델리게이트 등록
        textField.delegate = self
        // 편집
        if let checklist = checklistToEdit {
            title = "\(checklist.name)리스트 편집🛠"
            textField.text = checklist.name
            iconName = checklist.iconName // configure
        }
        // 추가
        else{
            doneBarButton.isEnabled = false
        }
        // UI에 이미지 반영
        iconImage.image = UIImage( named: iconName )
        navigationItem.largeTitleDisplayMode = .never
    }
        //2.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // text field 가 제일 먼저 포커스를 받는다.
        if checklistToEdit == nil { textField.becomeFirstResponder() }
    }
    //MARK: - 테이블뷰 델리게이트
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil // 1 section을 고를 수 있게 해 두었다.
    }
    // MARK: - UI Button 액션 메서드
        // 1).
    @IBAction func done(){
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = self.iconName
            delegate?.addListViewController( self, didFinishEditing: checklist ) // checklist객체 담아서
        }
        else{
            let checklist = Checklist()
            checklist.iconName = self.iconName
            checklist.name = textField.text!
            delegate?.addListViewController(self, didFinishAdding: checklist)
        }
    }
        // 2).
    @IBAction func cancel(){
        delegate?.addListViewControllerDidCancel(self)
    }
    // MARK: - 텍스트 필드 델리게이트 메서드
        //1).
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range( range, in: oldText )! // NSRange obj.
        let newText = oldText.replacingCharacters( in: stringRange, with: string )
        doneBarButton.isEnabled = ( !newText.isEmpty )
        return true
    }
        // 2).
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count != 0{
            done()
        }
        return true
    }
        //3).
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    // MARK: - 세그웨이 셋업
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pick_icon"{
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
            // 다음 뷰컨트롤러의 네비게이션 백버튼 설정 !!
            let backItem = UIBarButtonItem()
            backItem.title = "선택 완료"
            navigationItem.backBarButtonItem = backItem
        }
    }
    // 끝
}
