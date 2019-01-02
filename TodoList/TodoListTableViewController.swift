//
//  TodoListTableViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/15/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import Firebase

class TodoListTableViewController: UITableViewController {

    var ToDoList = [ToDo]()
    var refToDoList: DatabaseReference!
    var refHandle: DatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refToDoList = Database.database().reference()
        
        loadTodoList()
        
    }
    
    // MARK: - Logic

    
    func loadTodoList() {
        refHandle = refToDoList.child("ToDoList").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary)
                
                let id = dictionary["id"]
                let title = dictionary["Title"]
                let deteil = dictionary["Deteil"]
                let created = dictionary["Created"]
                let location = dictionary["Location"]
                let lat = dictionary["Latitude"]
                let lng = dictionary["Longitude"]
                
                self.ToDoList.insert(ToDo(id: id as? String, titlename: title as? String, deteil: deteil as? String, create_date: created as? String, location: location as? String, lat: lat as? Double, lng: lng as? Double), at: 0)
                
                self.tableView.reloadData()
                self.refToDoList.keepSynced(true)
            }
        })
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoList.count
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let TodoCell : ToDo
        TodoCell = ToDoList[indexPath.row ]
        let deteillbl = cell.detailTextLabel
        deteillbl?.textColor = UIColor.lightGray
        
        cell.textLabel?.text = TodoCell.titlename
        cell.detailTextLabel?.text = TodoCell.deteil
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TodoCell = ToDoList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Show") as? CompleteToDoViewController
        vc?.TitleName = TodoCell.titlename
        vc?.Created_Date = TodoCell.create_date
        vc?.Location = TodoCell.location
        vc?.Deteil = TodoCell.deteil
        self.show(vc!, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
}

