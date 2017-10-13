//
//  Posts.swift
//  CityView
//
//  Created by admin on 6/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
struct Posts {
    
    let key: String
    let id: String
//    let uId: String
    let text: String
    let imageURL: String
    let lat: String
    let long: String
    let emotion:String
    //let coordinate: CLLocationCoordinate2D
    var ref = DatabaseReference()
    
    init( id: String, text: String, image: String, lat: String, long: String, emotion: String, key: String = "") {
        self.key = key
        self.id = id
//        self.uId = uid
        self.text = text
        self.imageURL = image
        self.lat = lat
        self.long = long
        self.emotion = emotion
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        id = snapshotValue["id"] as! String
//        uId = snapshotValue["uid"] as! String
        text = snapshotValue["text"] as! String
        imageURL = snapshotValue["image"] as! String
        lat = snapshotValue["lat"] as! String
        long = snapshotValue["long"] as! String
        emotion = snapshotValue["emotion"] as! String
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
//            "uId": uId,
            "text": text,
            "image": imageURL,
            "long": long,
            "lat": lat,
            "emotion": emotion
        ]
    }
    
}
