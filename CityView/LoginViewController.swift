//
//  LoginViewController.swift
//  wip_meenagram

//

import UIKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in. Show home screen
                self.goToHome()
                print("Logged in")
            } else {
                // No User is signed in. Show user the login screen
                print("Not logged in")
            }
        }    }
    
    func login(){
       Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
        if error != nil{
            print(error!)
            return
        }
        
        self.goToHome()
       })
    }
    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    func goToHome(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(mapVC, animated: true, completion: nil )


    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        login()
    }
    @objc func dismissKeyboard(_ sender: Any) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
