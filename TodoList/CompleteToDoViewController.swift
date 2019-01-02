//
//  DisplayToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/21/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import Firebase

class CompleteToDoViewController: UIViewController {
    
    var ShowDeteil: String?
    
    var destinationShow = [ToDo]()
    var showdata : ToDo?
        
        
//    let selectedToDo : ToDo = []
    
    @IBOutlet weak var showdetail_textview: UITextView!
    @IBOutlet weak var lat_lbl: UILabel!
    @IBOutlet weak var lng_lbl: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var location_lbl: UILabel!
    @IBOutlet weak var setTitlePlace_btn: UIButton!
    @IBOutlet weak var time_lbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        time_lbl.text = selectedToDo.create_date
//        titlelabel.text = selectedToDo.titlename
//        location_lbl.text = selectedToDo.location
//        showdetail_textview.text = selectedToDo.deteil
//        lat_lbl.text = String(selectedToDo.lat)
//        lng_lbl.text = String(selectedToDo.lng)
        setTitlePlace_btn.setTitle("", for: .normal)
        
        // navigation right bar button (Complete)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(completeToDo))
        
        Database.database().reference().child("ToDoList").observeSingleEvent(of: .value) { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject] {
                self.titlelabel.text = dic["Title"] as? String
            }
        }
        

    }
    
    // MARK: - Logic
    
    @objc func completeToDo() {
//        let selectedToDo : ToDo
//        var index = 0
//
//        for toDo in backToDoListVC.ToDoList {
//            if toDo.titlename == selectedToDo.titlename {
//                backToDoListVC.ToDoList.remove(at: index)
//                backToDoListVC.tableView.reloadData()
//                navigationController?.popViewController(animated: true)
//                break
//            }
//            index += 1
//        }
    }
    
    // MARK: - Interface
    

}
