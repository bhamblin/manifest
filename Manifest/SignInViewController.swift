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
    
    @IBAction func handleSignIn(_ sender: AnyObject) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("ERROR: ", error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handlePop(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
