//
//  ViewController.swift
//  CityView
//
//  Created by admin on 6/27/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import AVKit
import AVFoundation

class ViewController: UIViewController {
    var posts: [Posts] = []
    var selectedPosts: [Posts] = []
    var ref = DatabaseReference()
    //let
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var currentLocationBtn: UIButton!
    var latitudePlace: Double?
    var longitudePlace: Double?
    
    @IBOutlet weak var contenctView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var contentCaption: UILabel!
    
    var player:AVPlayer?
    var playerLayer:AVPlayerLayer?
    var mediaType:String = ""
    var videoURL:String = ""
    
    
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var notiBtn: UIButton!
    
    @IBOutlet weak var ARbtn: UIButton!
    var photoBtnCenter: CGPoint!
    var findBtnCenter: CGPoint!
    var notiBtnCenter: CGPoint!
    var ARBtnCenter: CGPoint!
    var moreClickNumber = 0
    
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        ref = Database.database().reference(withPath: "posts-items")
        self.navigationController?.isNavigationBarHidden = true
        
        photoBtnCenter = photoBtn.center
        findBtnCenter = findBtn.center
        notiBtnCenter = notiBtn.center
        ARBtnCenter = ARbtn.center
        
        photoBtn.center = moreBtn.center
        findBtn.center = moreBtn.center
        notiBtn.center = moreBtn.center
        ARbtn.center = moreBtn.center
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissBtnGroup(_:)))
//        //tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
                //self.present(ExampleProvider.systemStyle(), animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.photoBtn.alpha = 0
        self.findBtn.alpha = 0
        self.notiBtn.alpha = 0
        self.ARbtn.alpha = 0
        moreClickNumber = 0
        contenctView.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        pauseVideo()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let sb = UIStoryboard(name: "Main2", bundle: nil)
            let loginVC = sb.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            
            self.present(loginVC, animated: true, completion: nil)
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    func fetchNearbyPlaces() {
        mapView.clear()
        ref.observe(.value, with: { snapshot in
            var newItems: [Posts] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let posts = Posts(snapshot: item as! DataSnapshot)
                newItems.append(posts)
            }
            
            // 5
            self.posts = newItems
            
            for place: Posts in self.posts {
                let marker = Places(post: place)
                marker.map = self.mapView
            }
        })

    }
    
    func fetchPlacesWithinOneKM(lat: Double, long: Double) {
        let currentCoordinate = CLLocation(latitude:lat, longitude:long)
        var index: Int = 0
        for var i in (0..<posts.count){
            let coordinate = CLLocation(latitude: Double(posts[i].lat)! , longitude: Double(posts[i].long)!)
            var distance = currentCoordinate.distance(from: coordinate)
            print("distance: ", distance)
            if distance < 1000{
                selectedPosts.insert(posts[i], at: index)
                print("post image: ", selectedPosts[index].imageURL)
                index=index+1

            }
        }
        
    }
    
    @IBAction func moreClick(_ sender: UIButton) {
        if moreClickNumber%2 == 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.photoBtn.alpha = 1
                self.findBtn.alpha = 1
                self.notiBtn.alpha = 1
                self.ARbtn.alpha = 1
                self.photoBtn.center = self.photoBtnCenter
                self.findBtn.center = self.findBtnCenter
                self.notiBtn.center = self.notiBtnCenter
                self.ARbtn.center = self.ARBtnCenter
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: { 
                self.photoBtn.alpha = 0
                self.findBtn.alpha = 0
                self.notiBtn.alpha = 0
                self.ARbtn.alpha = 0
                self.photoBtn.center = self.moreBtn.center
                self.findBtn.center = self.moreBtn.center
                self.notiBtn.center = self.moreBtn.center
                self.ARbtn.center = self.moreBtn.center
            })
            
        }
        moreClickNumber = moreClickNumber+1
    }
    
    @IBAction func avatarClick(_ sender: Any) {
        let Avatarvc: ProfileViewController? = self.storyboard?.instantiateViewController(withIdentifier: "AvatarVC") as? ProfileViewController
        self.navigationController?.isNavigationBarHidden = false
        Avatarvc?.posts = posts
//        self.navigationController?.pushViewController(Avatarvc!, animated: true)
        self.present(Avatarvc!, animated: true, completion: nil)
    }
    
    @IBAction func currentLocationClick(_ sender: Any) {
        let lat = self.mapView.myLocation?.coordinate.latitude
        let long = self.mapView.myLocation?.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 15.0)
        self.mapView.animate(to: camera)
    }
    
    @IBAction func photoBtnClick(_ sender: Any) {
        let Photovc: CreateViewController? = self.storyboard?.instantiateViewController(withIdentifier: "PhotoVC") as? CreateViewController
            self.present( Photovc!, animated: true, completion: nil)
    }
    
    @IBAction func findBtnClick(_ sender: Any) {
    }
    
    @IBAction func notiBtnClick(_ sender: Any) {
    }

    @IBAction func closeView(_ sender: Any) {
        contenctView.isHidden = true
        pauseVideo()
        
    }
    func pauseVideo(){
        if self.player != nil {
            DispatchQueue.main.async() {
                self.player!.pause()
                //                self.playerController!.view.removeFromSuperview()
            }
        }
    }
    @IBAction func ARbtnClick(_ sender: Any) {
        let sb = UIStoryboard(name: "Main3", bundle: nil)
        let arVC = sb.instantiateViewController(withIdentifier: "ARVC") as! MainViewController
        self.present(arVC, animated: true, completion: nil)
    }
    
    @IBAction func ContentARClick(_ sender: Any) {
        let sb = UIStoryboard(name: "Main3", bundle: nil)
        let arVC = sb.instantiateViewController(withIdentifier: "ARVC") as! MainViewController
        if self.mediaType == "photo" || self.mediaType == "" {
            arVC.contentPhoto = contentImageView.image
        }else if self.mediaType == "video"{
            arVC.videoURL = self.videoURL
        }
        arVC.latitude = latitudePlace
        arVC.longitude = longitudePlace
        arVC.mediaType = self.mediaType
        self.present(arVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            //mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            fetchNearbyPlaces()
            fetchPlacesWithinOneKM(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            
        }
    }
}

// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        addressLabel.lock()
        
        if (gesture) {
//            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
//        let placeMarker = marker as! Places
//        print("touch marker")
//        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
//            infoView.captionText.text = placeMarker.post.text
////             infoView.imageView.loadImageUsingCacheWithUrlString(placeMarker.post.imageURL)
//            let photoURL = placeMarker.post.imageURL
//            if (photoURL).isEmpty {
//               
//                infoView.imageView.image = UIImage(named: "avatar")
//            } else {
//                infoView.imageView.loadImageUsingCacheWithUrlString(photoURL)
//            }
//            
//            return infoView
//        } else {
//            return nil
//        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        mapCenterPinImage.fadeOut(0.25)
            let placeMarker = marker as! Places
            contentCaption.text = placeMarker.post.text
            let photoURL = placeMarker.post.imageURL
            latitudePlace = Double(placeMarker.post.lat)!
            longitudePlace = Double(placeMarker.post.long)!
//        contentImageView.removeFromSuperview()
        self.contentImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        if (placeMarker.post.emotion == "photo" || placeMarker.post.emotion == ""){
            
            if (photoURL).isEmpty {
                contentImageView.image = UIImage(named: "avatar")
                //infoView.imageView.image = UIImage(named: "avatar")
                
            } else {
                contentImageView.loadImageUsingCacheWithUrlString(photoURL)
            }
        }else if (placeMarker.post.emotion == "video"){
            let videoURL = URL(string: photoURL)
            if let thumbnailImage = getThumbnailImage(forUrl: videoURL!) {
                contentImageView.image = thumbnailImage
//                contentImageView.transform = contentImageView.transform.rotated(by: CGFloat(M_PI_2))
            }
             player = AVPlayer(url: videoURL!)
             playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = CGRect(x: 0.0, y: 0.0, width: contentImageView.frame.size.width, height: contentImageView.frame.size.height)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer?.masksToBounds = true
            
            contentImageView.layer.addSublayer(playerLayer!)
            player?.play()
            self.videoURL = photoURL
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        }
        mediaType = placeMarker.post.emotion
        contenctView.isHidden = false
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
}




