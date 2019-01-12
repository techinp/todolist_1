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
    
    
    var ToDoList = [ToDoModel]()
    var desComplete = TodoListTableViewController()
    var refToDoList: DatabaseReference!
    var refHandle: DatabaseHandle!
    

    // var for recieve data from tableview
    var Id_FIR: String?
    var TitleName: String?
    var Created_Date: String?
    var Modified_Date: String?
    var Location: String?
    var Detail: String?
    var Latitude: Double?
    var Longitude: Double?
    var indexP: Int?
    var path: IndexPath?
    
    // keyboard
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero
    
    // OutLet
    @IBOutlet weak var showdetail_textview: UITextView!
    @IBOutlet weak var location_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let red = hexStringToUIColor(hex: "#e74c3c")

        pullDataFIR()
        
        showdetail_textview.layer.borderWidth = 2.0
        showdetail_textview.layer.borderColor = red.cgColor
        location_lbl.textColor = UIColor.gray
        
        let complete_icon = UIImage(named: "Checkmark.png")
        let complete_action = UIBarButtonItem(image: complete_icon, style: .plain, target: self, action: #selector(editData))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: complete_icon, style: .plain, target: self, action: #selector(editData))
        let google_maps_icon = UIImage(named: "Googlemaps.png")
        let google_maps_action = UIBarButtonItem(image: google_maps_icon, style: .plain, target: self, action: #selector(openGoogle))
        
        navigationItem.rightBarButtonItems = [complete_action, google_maps_action]
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: google_maps_icon, style: .plain, target: self, action: #selector(openGoogle))
        
        if #available(iOS 11.0, *) {
            setupNavigationBar()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func editData() {
        
        editToDo()
        
        self.desComplete.tableView.reloadRows(at: [self.path!], with: .automatic)
        
        navigationController?.popViewController(animated: true)

    }
    
    func editToDo() {
        
        // get time to label
        
        let date = Date()
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MMM dd, yyyy HH:mm"//:ss"
        let modified_time = " / Modified: " + dateformatter.string(from: date)
        
        //----------------------
        
        refToDoList = Database.database().reference()
        
        refHandle = refToDoList.child("ToDoList").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let childKey = snapshot.key

            if (self.Id_FIR == dictionary!["id"] as? String) {
                if (self.Detail! != self.showdetail_textview.text) || (self.TitleName! != self.titleTextField.text ) {
                    
                    print(self.indexP!)
                    self.refToDoList.child("ToDoList").child(childKey).child("Title").setValue(self.titleTextField.text)
                    self.refToDoList.child("ToDoList").child(childKey).child("Detail").setValue(self.showdetail_textview.text)
                    self.refToDoList.child("ToDoList").child(childKey).child("Modified").setValue(modified_time)
                    
                    print("Data Change")
                } else {
                     print("Data Not Change")
                }
            }
        })
        
    }
    
    @available(iOS 11.0, *)
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
//    @IBAction func opengg(_ sender: Any) {
//        openGoogle()
//        print("Open GoogleMap Succesfully")
//
//    }
    
    @objc func openGoogle() {
        
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
    
    // MARK: - Color
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

    // MARK: - Logic
    
    var Create_Modified_Date = ""
    
    func pullDataFIR() {
        
        titleTextField.text = TitleName
        if Modified_Date != nil {
            Create_Modified_Date += Created_Date!
            Create_Modified_Date += Modified_Date!
            time_lbl.text = Create_Modified_Date
            print(Create_Modified_Date)

        } else {
            time_lbl.text = Created_Date
            print(Created_Date!)
        }
        location_lbl.text = Location
        showdetail_textview.text = Detail
        
    }
       
    // MARK:- Keyboad
    
    enum KeyboardState {
        case unknown
        case entering
        case exiting
    }
    
    func keyboardState(for userinfo:[AnyHashable:Any], in view:UIView?) -> (KeyboardState, CGRect?) {
        var keyboardBegin = userinfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        var keyboardEnd = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        var keyBState : KeyboardState = .unknown
        var newRect : CGRect? = nil
        if let views = view {
            let coord = UIScreen.main.coordinateSpace
            keyboardBegin = coord.convert(keyboardBegin, to:views)
            keyboardEnd = coord.convert(keyboardEnd, to:views)
            newRect = keyboardEnd
            if !keyboardBegin.intersects(views.bounds) && keyboardEnd.intersects(views.bounds) {
                keyBState = .entering
            }
            if keyboardBegin.intersects(views.bounds) && !keyboardEnd.intersects(views.bounds) {
                keyBState = .exiting
            }
        }
        return (keyBState, newRect)
    }
    
    @objc func keyboardShow(_ notifi:Notification) {
        let userinfo = notifi.userInfo!
        let (state, keyboardEnd) = keyboardState(for:userinfo, in:self.showdetail_textview)
        if state == .entering {
            print("really showing")
            self.oldContentInset = self.showdetail_textview.contentInset
            self.oldIndicatorInset = self.showdetail_textview.scrollIndicatorInsets
            self.oldOffset = self.showdetail_textview.contentOffset
        }
        print("show")
        // no need to scroll, as the scroll view will do it for us
        // so all we have to do is adjust the inset
        if let keyboardEnd = keyboardEnd {
            let height = keyboardEnd.intersection(self.showdetail_textview.bounds).height
            self.showdetail_textview.contentInset.bottom = height
            self.showdetail_textview.scrollIndicatorInsets.bottom = height
        }
    }
    
    @objc func keyboardHide(_ notifi:Notification) {
        let userinfo = notifi.userInfo!
        let (state, _) = keyboardState(for:userinfo, in:self.showdetail_textview)
        if state == .exiting {
            print("really hiding")
            // restore original setup
            // we _don't_ do this; let the text view position itself
            // self.scrollView.contentOffset = self.oldOffset
            self.showdetail_textview.scrollIndicatorInsets = self.oldIndicatorInset
            self.showdetail_textview.contentInset = self.oldContentInset
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.showdetail_textview.resignFirstResponder()
//        self.titleTodoTextField.resignFirstResponder()
    }
    

}

