//
//  AddToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/16/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase


class AddToDoViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate {
    
    var backToDoListVC = TodoListTableViewController()
    
    var refToDoList: DatabaseReference!
    
    
    // keyboard
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero

    
    // initialized Firebase Realtime
    
    
    @IBOutlet weak var detail_lbl: UITextView!
    @IBOutlet weak var titleTodoTextField: UITextField!
    @IBOutlet weak var Location_lbl: UILabel!
    @IBOutlet weak var findLocation_btn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTapAround()
        
        updateUI()
        Location_lbl.text = ""        
        
        //Text View
        placeHolderforTextView()
        detail_lbl.layer.borderWidth = 2.0
        detail_lbl.layer.borderColor = UIColor.orange.cgColor
        
        // navigation right bar button (add)
        let save_icon = UIImage(named: "Save.png")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: save_icon, style: .plain, target: self, action: #selector(addToDodata))
        
        // Navigation
        if #available(iOS 11.0, *) {
            setupNavigationBar()
        } else {
            // Fallback on earlier versions
        }
        
        refToDoList = Database.database().reference().child("ToDoList")


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    @available(iOS 11.0, *)
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK:- Add data
    
    @objc func addToDodata() {
        
        needHaveTextToAdd()
        
        navigationController?.popViewController(animated: true)
        
    }
    
//    func getCoreData() {
//
//        // get time to label
//
//        let date = Date()
//        let dateformatter = DateFormatter()
//
//        dateformatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
//        let created_time = "Created: " + dateformatter.string(from: date)
//
//        let todo = ToDo(id: "", titlename: titleTodoTextField.text, deteil: detail_lbl.text, create_date: created_time, location: getAddress(from: placemark!), lat: lat, lng: lng)
//
//        backToDoListVC.ToDoList.insert(todo, at: 0)
//
//    }
    
    //MARK:- Firebase
    
    func addDataToFIR() {
        
        // get time to label
        
        let date = Date()
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        let created_time = "Created: " + dateformatter.string(from: date)
        
        //----------------------
        
        let key = refToDoList.childByAutoId().key
        
        let ToDoNoSQL = ["id": key,
                         "Title": titleTodoTextField.text! as String,
                         "Deteil": detail_lbl.text! as String,
                         "Created": created_time,
                         "Location": getAddress(from: placemark!) as String,
                         "Latitude": String(lat!),
                         "Longitude": String(lng!)
        ]
        
        refToDoList.child(key!).setValue(ToDoNoSQL)
        
        print("this Lat : " + "\(lat!)")
        print("this Lat : " + "\(lng!)")

        
    }
    
    func needHaveTextToAdd() {
        if titleTodoTextField.text == "" || Location_lbl.text == "" || detail_lbl.text == "" {
            alertDismiss()
        }
        else {
            addDataToFIR()
//            getCoreData()
        }
    }
    
    func alertDismiss() {
        let alert = UIAlertController(title: "Oops!", message: "Please fill up this form", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Keyboad
    
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
        let (state, keyboardEnd) = keyboardState(for:userinfo, in:self.detail_lbl)
        if state == .entering {
            print("really showing")
            self.oldContentInset = self.detail_lbl.contentInset
            self.oldIndicatorInset = self.detail_lbl.scrollIndicatorInsets
            self.oldOffset = self.detail_lbl.contentOffset
        }
        print("show")
        // no need to scroll, as the scroll view will do it for us
        // so all we have to do is adjust the inset
        if let keyboardEnd = keyboardEnd {
            let height = keyboardEnd.intersection(self.detail_lbl.bounds).height
            self.detail_lbl.contentInset.bottom = height
            self.detail_lbl.scrollIndicatorInsets.bottom = height
        }
    }
    
    @objc func keyboardHide(_ notifi:Notification) {
        let userinfo = notifi.userInfo!
        let (state, _) = keyboardState(for:userinfo, in:self.detail_lbl)
        if state == .exiting {
            print("really hiding")
            // restore original setup
            // we _don't_ do this; let the text view position itself
            // self.scrollView.contentOffset = self.oldOffset
            self.detail_lbl.scrollIndicatorInsets = self.oldIndicatorInset
            self.detail_lbl.contentInset = self.oldContentInset
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.detail_lbl.resignFirstResponder()
        self.titleTodoTextField.resignFirstResponder()
    }
    
    
    
    //MARK:- UITextView Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Something Here ..." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write Something Here ..."
            textView .textColor = UIColor.lightGray
        }
    }
    
    func placeHolderforTextView() {
        detail_lbl.text = "Write Something Here ..."
        detail_lbl.textColor = UIColor.lightGray
        detail_lbl.returnKeyType = .default
        detail_lbl.delegate = self
    }
    
    // Hide Keyboard
    
    func hideKeyBoardWhenPressingReturn() {
        titleTodoTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoardWhenPressingReturn()
        return true
    }
    
    // MARK: - Location
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var isUpdatingLocation = false
    var lastLocationError: Error?
    var lat: Double?
    var lng: Double?
    
    
    
    func updateUI() {
        if location != nil {
            if let placemark = placemark {
                Location_lbl.text = getAddress(from: placemark )
                lat = location?.coordinate.latitude
                lng = location?.coordinate.longitude
               
            } else if isPerformingReverseGeocoding {
                Location_lbl.text = "address Not Found"
            } else if lastGeocodingError != nil {
                Location_lbl.text = "Error finding a valid address."
            } else {
                Location_lbl.text = "Searching for address..."
            }
        } else {
            Location_lbl.text = "Click here to find location"
        }
    }
    
    
    func getAddress(from placemark: CLPlacemark) -> String {
        var location_placeMark = ""
        if let name = placemark.name {
            location_placeMark += name + " "
        }
        if let subLocality = placemark.subLocality {
            location_placeMark += subLocality + " "
        }
        if let province = placemark.administrativeArea {
            location_placeMark += province + " "
        }
        if let postcode = placemark.postalCode {
            location_placeMark += postcode + " "
        }
    
        return location_placeMark
    }
    
    
    
    func  reportLocationServiceDeniedError() {
        let alert = UIAlertController(title: "Location Service Disbled" , message: "Plese go to eneble location service >", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // geocoder
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var isPerformingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    
    
    // Find Location
    
    @IBAction func findLocationbtn(_ sender: Any) {
        
        
        // 1: get permission from user
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        // 2: report if permission is denied
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            reportLocationServiceDeniedError()
            return
        }
        
        // 3: Start / Stop find location
        if isUpdatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            
            placemark = nil
            lastGeocodingError = nil
            
            startLocationManager()
            findLocation_btn.setTitle("", for: .normal)
        }
        updateUI()
    }
    
    func stopLocationManager() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdatingLocation = false
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }

}


extension AddToDoViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!!! locationManager-didFailWithError: \(error)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.last!
        print("GOT IT!!! locationManager-didUpdateLocationw: \(locations)")
        stopLocationManager()
        updateUI()
        
        if location != nil {
            if !isPerformingReverseGeocoding {
                print("*** Start performing geocoding... ")
                isPerformingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(location!) { (placemarks, error ) in
                    self.lastGeocodingError = error
                    if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
                        self.placemark = placemarks.last!
                    } else {
                        self.placemark = nil
                    }
                    
                    self.isPerformingReverseGeocoding = false
                    self.updateUI()
                }
            }
        }
    }
}

// Hide KeyBoard

//extension UIViewController {
//    func hideKeyboardWhenTapAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.DismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func DismissKeyboard() {
//        view.endEditing(true)
//    }
//}


