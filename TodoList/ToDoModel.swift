//
//  ToDo.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/15/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import Firebase

class ToDoModel {
    var id: String!
    var titlename: String!
    var detail: String!
    var create_date: String!
    var location: String!
    var lat: Double!
    var lng: Double!
    
    init(id: String? , titlename: String? , detail: String? , create_date: String? , location: String? , lat: Double? , lng: Double?) {
        self.id = id
        self.titlename = titlename
        self.detail = detail
        self.create_date = create_date
        self.location = location
        self.lat = lat
        self.lng = lng
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! NSDictionary
        id = snapshotValue["id"] as? String
        titlename = snapshotValue["Title"] as? String
        detail = snapshotValue["Detail"] as? String
        create_date = snapshotValue["Create"] as? String
        location = snapshotValue["Location"] as? String
        lat = snapshotValue["Latitude"] as? Double
        lng = snapshotValue["Longitude"] as? Double        
    }
    
}
