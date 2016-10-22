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
    
    @IBAction func returnKey(_ sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    
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

        let paddingViewFull = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 44))
        fullNameTextField.leftView = paddingViewFull
        fullNameTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingViewUser = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 44))
        userNameTextField.leftView = paddingViewUser
        userNameTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingViewEmail = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 44))
        emailTextField.leftView = paddingViewEmail
        emailTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingViewPassword = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 44))
        passwordTextField.leftView = paddingViewPassword
        passwordTextField.leftViewMode = UITextFieldViewMode.always
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


