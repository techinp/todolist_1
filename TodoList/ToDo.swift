//
//  ToDo.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/15/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import Firebase

class ToDo {
    var id: String?
    var titlename: String?
    var deteil: String?
    var create_date: String?
//    var modified_date: String?
    var location: String?
    var lat: Double?
    var lng: Double?
    
    init(id: String? , titlename: String? , deteil: String? , create_date: String? , /*modified_date: String? ,*/ location: String? , lat: Double? , lng: Double?) {
        self.id = id
        self.titlename = titlename
        self.deteil = deteil
        self.create_date = create_date
//        self.modified_date = modified_date
        self.location = location
        self.lat = lat
        self.lng = lng
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as? String
        titlename = snapshotValue["Title"] as? String
        deteil = snapshotValue["Deteil"] as? String
        create_date = snapshotValue["Create"] as? String
        location = snapshotValue["Location"] as? String
        lat = snapshotValue["Latitude"] as? Double
        lng = snapshotValue["Longitude"] as? Double
        
    }
    
}
