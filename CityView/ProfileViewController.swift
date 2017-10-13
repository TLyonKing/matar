//
//  ProfileViewController.swift
//  CityView
//
//  Created by admin on 7/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    var posts: [Posts] = []
//    var ref = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ref = Database.database().reference(withPath: "posts-items")
        myTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
//        ref.observe(.value, with: { snapshot in
//            var newItems: [Posts] = []
//            
//            // 3
//            for item in snapshot.children {
//                // 4
//                let posts = Posts(snapshot: item as! DataSnapshot)
//                newItems.append(posts)
//            }
//            
//            // 5
//            self.posts = newItems
//        })
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getUpdate(_ indexPath: IndexPath) -> Posts {
//        return self.posts[indexPath.row]
//        
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileUpdateCell") as! ProfileUpdateCell
        cell.renderWithUpdate(self.posts[indexPath.row])
        return cell
    }
    
    
    
}

class ProfileUpdateCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var imageViewContent: UIImageView!
    
    func renderWithUpdate(_ update: Posts) {
        nameLabel.text = "iamusername"
        bodyLabel.text = update.text
        
        if (update.imageURL).isEmpty {
            imageViewContent.image = UIImage(named: "avatar")
        } else {
            imageViewContent.loadImageUsingCacheWithUrlString(update.imageURL)
        }

    }
    
}
