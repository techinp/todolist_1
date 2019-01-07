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
    var Location: String?
    var Detail: String?
    var Latitude: Double?
    var Longitude: Double?
    
    // keyboard
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: complete_icon, style: .plain, target: self, action: #selector(editData))
        
        if #available(iOS 11.0, *) {
            setupNavigationBar()
        } else {
            // Fallback on earlier versions
        }
        

    }
    
    @objc func editData() {
        
        editToDo()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func editToDo() {
        
        refToDoList = Database.database().reference()
        
        refHandle = refToDoList.child("ToDoList").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let childKey = snapshot.key
            
            if (self.Id_FIR == dictionary!["id"] as? String) {
                self.refToDoList.child("ToDoList").child(childKey).child("Detail").setValue(self.showdetail_textview.text)
            
            }
        })
        
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

        titlelabel.text = TitleName
        time_lbl.text = Created_Date
        location_lbl.text = Location
        showdetail_textview.text = Detail
        
    }
   

    // MARK: - Interface
    
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
