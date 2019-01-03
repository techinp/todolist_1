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

    var ToDoList = [ToDoModel]()
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
            if let dictionary = snapshot.value as? NSDictionary {
                print(dictionary)
                
               
                
                let id = dictionary["id"] as? String
                let title = dictionary["Title"] as? String
                let deteil = dictionary["Deteil"] as? String
                let created = dictionary["Created"] as? String
                let location = dictionary["Location"] as? String
                let lat = dictionary.value(forKey: "Latitude") as? String
                let lng = dictionary.value(forKey: "Longitude") as? String
                
                
                let DLat = Double(lat!)
                let Dlng = Double(lng!)
                
                
                print(title!)
                print(lat!)
                print(lng!)
                
                self.ToDoList.insert(ToDoModel(id: id , titlename: title , deteil: deteil , create_date: created , location: location , lat: DLat, lng: Dlng), at: 0)
                
                self.tableView.reloadData()
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
        
        let TodoCell : ToDoModel
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
        vc?.Latitude = TodoCell.lat
        vc?.Longitude = TodoCell.lng
        print(TodoCell.lng)
        print(TodoCell.lat)
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

