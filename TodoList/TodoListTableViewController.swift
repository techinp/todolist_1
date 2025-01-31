//
//  TodoListTableViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/15/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import Firebase

class ListTableviewCell : UITableViewCell {
    
    
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var detail_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    
}

class TodoListTableViewController: UITableViewController {
    

    var ToDoList = [ToDoModel]()
    var refToDoList: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var modified_time: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refToDoList = Database.database().reference()
        
//        loadTodoList()
        
        setupNavigationBar()
        
        let red = hexStringToUIColor(hex: "#e74c3c")
        navigationController?.navigationBar.tintColor = red
                
        let add_icon = UIImage(named: "Add.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: add_icon, style: .plain, target: self, action: #selector(gotoAddVC))
        
        let delete_icon = UIImage(named: "Delete.png")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: delete_icon, style: .plain, target: self, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        ToDoList.removeAll()
        loadTodoList()
//        self.tableView.reloadData()
    }
    
    // MARK: - Logic
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc func gotoAddVC() {
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddToDoViewController
        self.show(addVC!, sender: self)
    }
    
    
    func setupNavigationBar() {
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {

        }
    }

    
    func loadTodoList() {
        refHandle = refToDoList.child("ToDoList").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {

                let id = dictionary["id"] as? String
                let title = dictionary["Title"] as? String
                let detail = dictionary["Detail"] as? String
                let created = dictionary["Created"] as? String
                let modified = dictionary["Modified"] as? String
                let location = dictionary["Location"] as? String
                let lat = dictionary.value(forKey: "Latitude") as? String
                let lng = dictionary.value(forKey: "Longitude") as? String
                
                let DLat = Double(lat!)
                let Dlng = Double(lng!)
                
                self.ToDoList.insert(ToDoModel(id: id , titlename: title , detail: detail , create_date: created , modified_date: modified , location: location , lat: DLat, lng: Dlng), at: 0)
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableviewCell
        
        let TodoCell : ToDoModel

        TodoCell = ToDoList[indexPath.row ]
        
        cell.title_lbl.text = TodoCell.titlename
        cell.detail_lbl.text = TodoCell.detail
        if TodoCell.modified_date != nil {
            cell.time_lbl.text = "\(String(TodoCell.create_date))\(String(TodoCell.modified_date))"
        } else {
            cell.time_lbl.text = TodoCell.create_date
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TodoCell = ToDoList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowVC") as? CompleteToDoViewController
        vc?.Id_FIR = TodoCell.id
        vc?.TitleName = TodoCell.titlename
        vc?.Created_Date = TodoCell.create_date
        vc?.Modified_Date = TodoCell.modified_date
        vc?.Location = TodoCell.location
        vc?.Detail = TodoCell.detail
        vc?.Latitude = TodoCell.lat
        vc?.Longitude = TodoCell.lng
        vc?.indexP = indexPath.row
        vc?.path = indexPath
        self.show(vc!, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.reloadData()
        }
    }
    
}
