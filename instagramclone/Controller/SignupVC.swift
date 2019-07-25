//
//  SignupVC.swift
//  instagramclone
//
//  Created by MISHAL ALHAJRI on 19/11/1440 AH.
//  Copyright © 1440 Torch. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD
class SignupVC: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    var uid : String?
    var selectedImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePressed))
        profileImg.addGestureRecognizer(gesture)
        profileImg.isUserInteractionEnabled = true
        errorLabel.isHidden = true
        
        chnageFieldProprties(textField: passwordTextField)
        chnageFieldProprties(textField: nameTextField)
        chnageFieldProprties(textField: emailTextField)
        
    }
    @objc func imagePressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker,animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAccountPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Signin up")
        if nameTextField.text!.isEmpty {
            SVProgressHUD.showError(withStatus: "Username is empty")
            return
        } else if emailTextField.text!.isEmpty {
            SVProgressHUD.showError(withStatus: "Email is empty")
            return
        }
        else if passwordTextField.text!.isEmpty {
            SVProgressHUD.showError(withStatus: "Password is empty")
            return
        }
        else {
            
            AuthService.root.signUp(selectedImg: self.selectedImage, username: self.nameTextField.text!, password: self.passwordTextField.text!, email: self.emailTextField.text!, onSucess: {
                SVProgressHUD.showSuccess(withStatus: "Good job")
                self.performSegue(withIdentifier: "fromSignupToTabBar", sender: nil)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error!)
            }
        }
    }
    func chnageFieldProprties(textField : UITextField) {
        textField.backgroundColor = .clear
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension SignupVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            profileImg.image = image
        }
        print("finished picking!")
        dismiss(animated: false, completion: nil)
    }
    
}
