//
//  BaseNode.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import SceneKit
import UIKit
import ARKit
import CoreLocation

class BaseNode: SCNNode {
    
    let title: String
    var anchor: ARAnchor?
    var location: CLLocation!
    
    init(title: String, location: CLLocation) {
        self.title = title
        super.init()
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
    }
    
    func createPlaneNode(image:UIImage)-> SCNNode{
        let sphereNode = SCNNode()
        //                    let sphere = SCNSphere(radius: 0.1)
        let imagePlane = SCNPlane(width: 0.1, height: 0.1*1.5)
        imagePlane.firstMaterial?.diffuse.contents = image
//        sphereNode.movabilityHint = .movable
        sphereNode.addChildNode(SCNNode(geometry: imagePlane))
        return sphereNode
    }

    func addPlane(image:UIImage) {
        let planeNode = createPlaneNode(image: image)
        addChildNode(planeNode)
    }
    
    func createPlaneNode1(view:Any)-> SCNNode{
        let sphereNode = SCNNode()
        //                    let sphere = SCNSphere(radius: 0.1)
        let imagePlane = SCNPlane(width: 0.3, height: 0.3*1.5)
        imagePlane.firstMaterial?.diffuse.contents = view
        //        sphereNode.movabilityHint = .movable
        sphereNode.addChildNode(SCNNode(geometry: imagePlane))
        return sphereNode
    }
    
    func addPlane1(view:Any) {
        let planeNode = createPlaneNode1(view: view)
        addChildNode(planeNode)
    }
    
    func addSphere(with radius: CGFloat, and color: UIColor) {
        let sphereNode = createSphereNode(with: radius, color: color)
        addChildNode(sphereNode)
    }
    
    func addNode(view:Any) {
        let sphereNode = createPlaneNode1(view: view)
//        let newText = SCNText(string: "SHIT", extrusionDepth: 1.0)
//        newText.font = UIFont (name: "AvenirNext-Medium", size: 16)
//        newText.firstMaterial?.diffuse.contents = UIColor.red
//        let _textNode = SCNNode(geometry: newText)
        let annotationNode = createSphereNode(with: 0.1, color: .blue)
//        annotationNode.addChildNode(_textNode)
        annotationNode.position = sphereNode.position
        addChildNode(sphereNode)
        addChildNode(annotationNode)
    }
}

