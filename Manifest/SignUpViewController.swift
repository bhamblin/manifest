//
//  ViewController.swift
//  Manifest
//
//  Created by Bradley Hamblin on 10/9/16.
//  Copyright © 2016 Bradley Hamblin. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func handleSignUp(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("ERROR: ", error)
            } else {
                var ref: FIRDatabaseReference!
                
                ref = FIRDatabase.database().reference()
                ref.child("users/\(user!.uid)/username").setValue(self.userNameTextField.text!)
                ref.child("users/\(user!.uid)/fullname").setValue(self.fullNameTextField.text!)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
                
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

