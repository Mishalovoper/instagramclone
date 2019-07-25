//
//  ViewController.swift
//  instagramclone
//
//  Created by MISHAL ALHAJRI on 19/11/1440 AH.
//  Copyright © 1440 Torch. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
class LoginVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chnageFieldProprties(textField : emailTextField)
        chnageFieldProprties(textField : passwordTextField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loginToTabBar", sender: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func loginTapped(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Signing in")
        AuthService.root.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSucess: {
            self.performSegue(withIdentifier: "loginToTabBar", sender: nil)
            SVProgressHUD.showSuccess(withStatus: "Good job")
        }) { (err) in
            SVProgressHUD.showError(withStatus: err!)
        }
    }
}
func chnageFieldProprties(textField : UITextField) {
    textField.backgroundColor = .clear
    textField.textColor = UIColor.white
    textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
}




