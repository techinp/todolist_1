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
    var refToDoList: DatabaseReference!
    var refHandle: DatabaseHandle!

    // var for recieve data from tableview
    var Id_FIR: String?
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
        
        
        let complete_icon = UIImage(named: "Checkmark.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: complete_icon, style: .plain, target: self, action: #selector(completeToDo))
        
        if #available(iOS 11.0, *) {
            setupNavigationBar()
        } else {
            // Fallback on earlier versions
        }
        

    }
    
    @objc func completeToDo() {
        
        refToDoList = Database.database().reference()
//        refToDoList = Database.database().reference().child("ToDoList")
//        let key = refToDoList.childByAutoId().key
        
//        refToDoList.child(key!).setValue(ToDoNoSQL)
        print(Id_FIR!)
        
        refHandle = refToDoList.child("ToDoList").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let snapValue_Title = snapshot.value as? NSDictionary
            let snapValue_Detail = snapshot.value as? NSDictionary
            let childKey = snapshot.key
//            let key = self.refToDoList.childByAutoId().key

            if (self.Id_FIR == snapValue_Detail!["id"] as? String) {
                
                let ref = Database.database().reference()
                ref.child("ToDoList").child(childKey).child("Deteil").setValue(self.showdetail_textview.text)
                
                
            }
        })
        
    }
    
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
    
    
    @available(iOS 11.0, *)
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func opengg(_ sender: Any) {
        openGoogle()
        print("Open GoogleMap Succesfully")

    }
    
    func openGoogle() {
        
        let string = "https://www.google.com/maps/search/?api=1&query=\(String(Latitude!)),\(String(Longitude!))"
        let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoded)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
    }

    // MARK: - Logic
    
    func pullDataFIR() {
        let red = hexStringToUIColor(hex: "#e74c3c")

        titlelabel.text = TitleName
        time_lbl.text = Created_Date
        location_lbl.text = Location
        showdetail_textview.text = Deteil
        
    }
    
   

    // MARK: - Interface
    

}
