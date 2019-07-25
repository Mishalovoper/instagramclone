//
//  HomeVC.swift
//  instagramclone
//
//  Created by MISHAL ALHAJRI on 20/11/1440 AH.
//  Copyright © 1440 Torch. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do{
        try
            Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let storyBoard = UIStoryboard(name: "Start", bundle: nil)
        let signinVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(signinVC,animated: true,completion: nil)
    }
    
}
