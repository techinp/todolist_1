//
//  AddToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/16/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit

class AddToDoViewController: UIViewController {
    
    var ToDoListVC = TodoListTableViewController()
    
    
    @IBOutlet weak var titleTodoTextField: UITextField!
    

    @IBOutlet weak var importantSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addToDobtn(_ sender: Any) {
        let todo = ToDo()
        todo.name = titleTodoTextField.text! // ให้ตัวแปร todo มีค่า name = titleTodoTextField
        todo.important = importantSwitch.isOn // ให้ตัวแปร todo มีค่า Boolean = 1

        ToDoListVC.TodoList.append(todo) // เพิ่มค่าที่ได้จาก todo เข้าตัวแปร ToDoList
        ToDoListVC.tableView.reloadData() // reload table view

        navigationController?.popViewController(animated: true)


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}