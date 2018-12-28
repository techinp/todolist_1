//
//  DisplayToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/21/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit

class CompleteToDoViewController: UIViewController {
    
    var backToDoListVC = TodoListTableViewController()
    var selectedToDo = ToDo()
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var location_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelabel.text = selectedToDo.name
        location_lbl.text = selectedToDo.location

    }
    
    // MARK: - Logic
    
    func completeToDo() {
        var index = 0
        
        for toDo in backToDoListVC.TodoList {
            if toDo.name == selectedToDo.name {
                backToDoListVC.TodoList.remove(at: index)
                backToDoListVC.tableView.reloadData()
                navigationController?.popViewController(animated: true)
                break
            }
            index += 1
        }
    }
    
    // MARK: - Interface
    
    @IBAction func completeToDo(_ sender: Any) {
        completeToDo()
    }
    

}
