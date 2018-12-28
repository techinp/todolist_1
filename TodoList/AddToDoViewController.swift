//
//  AddToDoViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/16/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import CoreLocation

class AddToDoViewController: UIViewController {
    
    var backToDoListVC = TodoListTableViewController()
    
    
    @IBOutlet weak var titleTodoTextField: UITextField!
    @IBOutlet weak var findLocation_lbl: UILabel!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var findLocation_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        findLocation_lbl.text = ""

    }
    
    // MARK: - Logic
    
    func addToDodata() {
        let todo = ToDo()
        
        if let titleText = titleTodoTextField.text {
            
            todo.name = titleText // ให้ตัวแปร todo มีค่า name = titleTodoTextField
            todo.important = importantSwitch.isOn // ให้ตัวแปร todo มีค่า Boolean = 1
            
            backToDoListVC.TodoList.insert(todo, at: 0)// เพิ่มค่าที่ได้จาก todo เข้าแถวแรกของตัวแปร ToDoList
            backToDoListVC.tableView.reloadData() // reload table view
            
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    // MARK: - Location
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var isUpdatingLocation = false
    var lastLocationError: Error?
    
    func updateUI() {
        if let location = location {
            if let placemark = placemark {
                findLocation_lbl.text = getAddress(from: placemark )
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
        if let street1 = placemark.subThoroughfare {
            line1 += street1 + " "
        }
        if let street2 = placemark.thoroughfare {
            line1 += street2 + " "
        }
        
        var line2 = ""
        if let city = placemark.locality {
            line2 += city + " "
        }
        if let state = placemark.administrativeArea {
            line2 += state + " "
        }
        if let postcode = placemark.postalCode {
            line2 += postcode + " "
        }
        
        var line3 = ""
        if let country = placemark.country {
            line3 += country
        }
        return line1 + "\n" + line2 + "\n" + line3
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
    
    
    
    // MARK: - Interface
    
    @IBAction func findLocationbtn(_ sender: Any) {
        
//        findLocation_btn.setTitle("", for: .normal)
//        findLocation_lbl.text = "Phuket"
        
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
    
    @IBAction func addToDobtn(_ sender: Any) {
        addToDodata()
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
