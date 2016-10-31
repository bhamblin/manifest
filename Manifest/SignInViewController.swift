//
//  SignInViewController.swift
//  Manifest
//
//  Created by Grzegorz Biesiadecki on 10/9/16.
//  Copyright © 2016 Bradley Hamblin. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func returnKey(_ sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    
    @IBAction func handleSignIn(_ sender: AnyObject) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("ERROR: ", error as! String)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handlePop(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
