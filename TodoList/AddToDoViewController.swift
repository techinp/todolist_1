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


class AddToDoViewController: UIViewController , UITextFieldDelegate {
    
    var backToDoListVC = TodoListTableViewController()
    
    // initialized Firebase Realtime
    
    
    @IBOutlet weak var titleTodoTextField: UITextField!
    @IBOutlet weak var findLocation_lbl: UILabel!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var findLocation_btn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapAround()
        
        updateUI()
        findLocation_lbl.text = ""
        
        // navigation right bar button (add)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addToDodata))
        

    }
    
    @objc func addToDodata() {
        let todo = ToDo()
        
        // get time to label
        
        let date = Date()
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        let result = "Created: " + dateformatter.string(from: date)
        
        if let titleText = titleTodoTextField.text {
            
            todo.name = titleText // ให้ตัวแปร todo มีค่า name = titleTodoTextField
            todo.important = importantSwitch.isOn // ให้ตัวแปร todo มีค่า Boolean = 1
            todo.location = getAddress(from: placemark!)
            todo.create_date = result
            todo.lat = lat!
            todo.lng = lng!
            
            backToDoListVC.TodoList.insert(todo, at: 0)// เพิ่มค่าที่ได้จาก todo เข้าแถวแรกของตัวแปร ToDoList
            backToDoListVC.tableView.reloadData() // reload table view
            
            navigationController?.popViewController(animated: true)
            
        }
        
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
                findLocation_lbl.text = getAddress(from: placemark )
                lat = location?.coordinate.latitude
                lng = location?.coordinate.longitude
            } else if isPerformingReverseGeocoding {
                findLocation_lbl.text = "address Not Found"
            } else if lastGeocodingError != nil {
                findLocation_lbl.text = "Error finding a valid address."
            } else {
                findLocation_lbl.text = "Searching for address..."
            }
        } else {
            findLocation_lbl.text = "Click here to find location"
        }
    }
    
    
    func getAddress(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let throughface = placemark.thoroughfare {
            line1 += throughface + " "
        }
        if let subLocality = placemark.subLocality {
            line1 += subLocality + " "
        }
        if let province = placemark.administrativeArea {
            line1 += province + " "
        }
        if let postcode = placemark.postalCode {
            line1 += postcode + " "
        }
    
        return line1
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

extension UIViewController {
    func hideKeyboardWhenTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.DismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}


