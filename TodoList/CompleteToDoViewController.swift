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
    
    
    var destinationShow = [ToDo]()
    var showdata : ToDo?
    var desComplete = TodoListTableViewController()
    var ref : DatabaseReference?
    var TitleName: String?
    var Created_Date: String?
    var Location: String?
    var Deteil: String?
    

    


        
        
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
        
        pullDataFIR()
        
        showdetail_textview.layer.borderWidth = 2.0
        showdetail_textview.layer.borderColor = UIColor.orange.cgColor
        
        location_lbl.textColor = UIColor.gray
        
//        time_lbl.text = selectedToDo.create_date
//        titlelabel.text = selectedToDo.titlename
//        location_lbl.text = selectedToDo.location
//        showdetail_textview.text = selectedToDo.deteil
//        lat_lbl.text = String(selectedToDo.lat)
//        lng_lbl.text = String(selectedToDo.lng)
        setTitlePlace_btn.setTitle("", for: .normal)
        
        // navigation right bar button (Complete)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(completeToDo))
        
//        Database.database().reference().child("ToDoList").observeSingleEvent(of: .value) { (snapshot) in
//            if let dic = snapshot.value as? [String: AnyObject] {
//                self.titlelabel.text = dic["Title"] as? String
//                self.time_lbl.text = dic["Created"] as? String
//                self.location_lbl.text = dic["Location"] as? String
//            }
//        }

    }
    
    
    // MARK: - Logic
    
    func pullDataFIR() {
        titlelabel.text = TitleName
        time_lbl.text = Created_Date
        location_lbl.text = Location
        showdetail_textview.text = Deteil
    }
    
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
