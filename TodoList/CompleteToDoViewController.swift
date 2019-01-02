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
    
    @IBOutlet weak var showdetail_textview: UITextView!
    @IBOutlet weak var lat_lbl: UILabel!
    @IBOutlet weak var lng_lbl: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var location_lbl: UILabel!
    @IBOutlet weak var setTitlePlace_btn: UIButton!
    @IBOutlet weak var time_lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time_lbl.text = selectedToDo.create_date
        titlelabel.text = selectedToDo.titlename
        location_lbl.text = selectedToDo.location
        showdetail_textview.text = selectedToDo.deteil
//        lat_lbl.text = String(selectedToDo.lat)
//        lng_lbl.text = String(selectedToDo.lng)
        setTitlePlace_btn.setTitle("", for: .normal)
        
        // navigation right bar button (Complete)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(completeToDo))

    }
    
    // MARK: - Logic
    
    @objc func completeToDo() {
        var index = 0
        
        for toDo in backToDoListVC.TodoList {
            if toDo.titlename == selectedToDo.titlename {
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
