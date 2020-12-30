//
//  TenGageViewController.swift
//  MintNudge
//
//  Created by 한석희 on 11/2/20.
//

import UIKit

protocol TenGageViewControllerDelegate  {
    func tenGageViewControllerDidDismiss(stepsList : [Step])
    func tenGageViewControllerDidDismissForEditing()
}

class TenGageViewController: UITableViewController {
    
    var checklistItem : ChecklistItem? = nil
    var delegate : TenGageViewControllerDelegate? = nil
    var stepsList : [Step] = [] // from add list came
    // 10grid_cell
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        if let checklistItem = checklistItem {
            return checklistItem.steps.list.count
        }
        else {
            return stepsList.count
        }
    }
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "10grid_cell", for: indexPath)
        //
        let textField = cell.viewWithTag(1) as! UITextField
        let uiSwitch = cell.viewWithTag(2) as! UISwitch
        //
        if let checklistItem = checklistItem  {
            textField.text! = checklistItem.steps.list[indexPath.row].task
            uiSwitch.isOn = checklistItem.steps.list[indexPath.row].isDone
        }else {
            textField.text! = stepsList[indexPath.row].task
            uiSwitch.isOn = stepsList[indexPath.row].isDone
        }
        //
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let checklistItem = checklistItem {
            for i in ( 0 ..< checklistItem.steps.list.count ){
                let cell = tableView.cellForRow( at: IndexPath(row: i, section: 0) )
                let textField = cell?.viewWithTag(1) as! UITextField
                let uiSwitch = cell?.viewWithTag(2) as! UISwitch
                checklistItem.steps.list[i].task = textField.text! // 비어있으면 닐인지 확인 !!
                checklistItem.steps.list[i].isDone = uiSwitch.isOn
            }
            delegate?.tenGageViewControllerDidDismissForEditing()
        }
        else{
            for i in ( 0..<self.stepsList.count ){
                let cell = tableView.cellForRow( at: IndexPath(row: i, section: 0) )
                
                let textField = cell?.viewWithTag(1) as! UITextField
                let uiSwitch = cell?.viewWithTag(2) as! UISwitch
                
                stepsList[i].task = textField.text! // 비어있으면 닐인지 확인 !!
                stepsList[i].isDone = uiSwitch.isOn
            }
            delegate?.tenGageViewControllerDidDismiss(stepsList: stepsList)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


