//
//  FeedViewController.swift
//  Manifest
//
//  Created by Grzegorz Biesiadecki on 10/9/16.
//  Copyright © 2016 Bradley Hamblin. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            print(user, "signed in")
        } else {
            print("not signed in")
            let signUpViewController = self.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
