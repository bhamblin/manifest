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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func handleSignUp(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("ERROR: ", error)
            } else {
                print("USER: ", user)
                let feedViewController = self.storyboard!.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
                self.present(feedViewController, animated: true, completion: nil)
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

