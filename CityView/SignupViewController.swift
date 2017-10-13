//
//  SignupViewController.swift
//

import UIKit
import Firebase


class SignupViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    let default_photo = "https://firebasestorage.googleapis.com/v0/b/meenagram-ac342.appspot.com/o/empty-profile.png?alt=media&token=0885c80a-8eab-4e66-a9d4-548d5527b773"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func signup(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                print(error!)
                return
            }else{
                
                self.createProfile(user!)
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let mapVC = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(mapVC, animated: true, completion: nil )
            }
        })
    }
    
    func createProfile(_ user: UserInfo){
        let delimiter = "@"
        guard let email = user.email else{return}
        let uName = email.components(separatedBy: delimiter)
        
        
        
        let newUser = User(id: user.uid ,bio: "", display: uName[0], email: email, photo: default_photo, username: uName[0])
        
        
        self.databaseRef.child("profile").child(user.uid).updateChildValues(newUser.getUserAsDictionary()) { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
            print("Profile successfully created")
        }
        
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text else{return}
        signup(email: email, password: password)
        
    }
    @objc func dismissKeyboard(_ sender: Any) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
