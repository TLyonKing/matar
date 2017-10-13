//
//  Places.swift
//  CityView
//
//  Created by admin on 7/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class Places: GMSMarker {
    let post: Posts
    
    init(post: Posts) {
        self.post = post
        super.init()
        
        let coordinate = CLLocationCoordinate2D(latitude: Double(post.lat)!, longitude: Double(post.long)!)
        position = coordinate
        let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView
        var emotionGif = ""
        
        if post.emotion == "photo" {
            emotionGif = "photo"
        }else if post.emotion == "video"{
            emotionGif = "video"
        }
        infoView?.gifImageView.image = UIImage.gif(name: emotionGif)
        iconView = infoView
//        icon = UIImage(named: "avatar_icon")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        //appearAnimation = kGMSMarkerAnimationPop
    }
}
