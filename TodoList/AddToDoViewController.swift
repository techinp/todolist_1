//
//  AddToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/16/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit

class AddToDoViewController: UIViewController {
    
    var backToDoListVC = TodoListTableViewController()
    
    
    @IBOutlet weak var titleTodoTextField: UITextField!
    

    @IBOutlet weak var importantSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Logic
    
    func addToDodata() {
        let todo = ToDo()
        
        if let titleText = titleTodoTextField.text {
            
            todo.name = titleText // ให้ตัวแปร todo มีค่า name = titleTodoTextField
            todo.important = importantSwitch.isOn // ให้ตัวแปร todo มีค่า Boolean = 1
            
            backToDoListVC.TodoList.insert(todo, at: 0)// เพิ่มค่าที่ได้จาก todo เข้าแถวแรกของตัวแปร ToDoList
            backToDoListVC.tableView.reloadData() // reload table view
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    // MARK: - Interface
    
    
    @IBAction func addToDobtn(_ sender: Any) {
        addToDodata()
    }

}
