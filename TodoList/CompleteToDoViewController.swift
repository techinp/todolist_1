//
//  DisplayToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/21/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class CompleteToDoViewController: UIViewController {
    
    
    var destinationShow = [ToDoModel]()
    var showdata : ToDoModel?
    var desComplete = TodoListTableViewController()
    var ref : DatabaseReference?
    var TitleName: String?
    var Created_Date: String?
    var Location: String?
    var Deteil: String?
    var Latitude: Double?
    var Longitude: Double?
    
    


        
        
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
        
        // https://www.google.com/maps/search/?api=1&query=47.5951518,-122.3316393

//        Alarmofirepull()
        
        
//        setTitlePlace_btn.setTitle("", for: .normal)
        
        // navigation right bar button (Complete)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(completeToDo))
        

    }
    
    @IBAction func opengg(_ sender: Any) {
        openGoogle()
        print("Open GoogleMap Succesfully")

    }
    
    func openGoogle() {
        
        let string = "https://www.google.com/maps/search/?api=1&query=\(String(Latitude!)),\(String(Longitude!))"
        let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoded)!
        UIApplication.shared.open(url)
    }

    // MARK: - Logic
    
//    func Alarmofirepull() {
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
//            
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }
//    }
    
    func pullDataFIR() {
        titlelabel.text = TitleName
        time_lbl.text = Created_Date
        location_lbl.text = Location
        showdetail_textview.text = Deteil
        
    }
    
    @objc func completeToDo() {
//        let selectedToDo : ToDo?
//        var index = 0
//
//        for toDo in desComplete.ToDoList {
//            if toDo.titlename == selectedToDo!.titlename {
//                desComplete.ToDoList.remove(at: index)
//                desComplete.tableView.reloadData()
//                navigationController?.popViewController(animated: true)
//                break
//            }
//            index += 1
//        }
    }

    // MARK: - Interface
    

}
