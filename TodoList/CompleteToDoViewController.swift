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
    @IBOutlet weak var setTitlePlace_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelabel.text = selectedToDo.name
        location_lbl.text = selectedToDo.location
        setTitlePlace_btn.setTitle("", for: .normal)
        
        // navigation right bar button (Complete)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(completeToDo))

    }
    
    // MARK: - Logic
    
    @objc func completeToDo() {
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
    

}
