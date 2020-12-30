//
//  IconPickerViewController.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/30/20.
//

import UIKit


protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker : IconPickerViewController, didPick iconName: String )
}

class IconPickerViewController: UITableViewController {
    //
    let icons = [
        "Study", "Appointments", "Birthdays", "Chores",
        "Drinks",  "Groceries", "Inbox", "Trips","No Icon"
      ]
    //
    let iconsK = [
        "공부📚", "약속🕺🏻", "생일🎉", "집안일🧹",
        "물 마시기🥛", "장보기🛒", "매일 확인✉️", "여행🏝","아이콘 없음❌"
      ]
    //
    weak var delegate : IconPickerViewControllerDelegate?
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "icon_cell", for: indexPath)
        //
        let iconName = icons[indexPath.row]
        let iconKName = iconsK[indexPath.row]
        //
        cell.textLabel!.text = iconKName
        cell.imageView!.image = UIImage(named: iconName)
        //
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPicker(self, didPick: icons[indexPath.row])
    }
    //
}
