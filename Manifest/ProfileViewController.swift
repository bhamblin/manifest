//
//  ProfileViewController.swift
//  Manifest
//
//  Created by Bradley Hamblin on 10/23/16.
//  Copyright © 2016 Bradley Hamblin. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
        
    @IBAction func handleLogout(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        self.tabBarController?.selectedIndex = 0

        //        self.tabBarController?.setViewControllers([!], animated: true)
        
        
        
       // let signInViewController = self.storyboard!.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
       // let signUpNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "SignUpNavigationController") as! UINavigationController
       // signUpNavigationController.pushViewController(signInViewController, animated: true)
       // self.navigationController?.present(signUpNavigationController, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
