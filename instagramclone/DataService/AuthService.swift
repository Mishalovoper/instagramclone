//
//  AuthService.swift
//  instagramclone
//
//  Created by MISHAL ALHAJRI on 21/11/1440 AH.
//  Copyright © 1440 Torch. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class AuthService {
    static var root = AuthService()
    var indicator = true
    
    // Signing in user!
    func signIn(email : String, password : String, onSucess : @escaping () -> Void , onFail : @escaping (_ error : String?) -> Void){
        if email.isEmpty {
        } else if password.isEmpty {
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    onFail(err!.localizedDescription)
                    return
                }
                onSucess()
            }
        }
    }
    
    
    
    
    
    
    
    // Signing up user
    
    
    func signUp(selectedImg: UIImage?, username : String, password : String, email : String, onSucess: @escaping () -> Void, onFail : @escaping ( _ err : String?) -> Void) {
        let ref = Database.database().reference().child("users")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                onFail(error!.localizedDescription)
                return
            }
            let userReference = ref.child(result!.user.uid)
            let storageReference = Storage.storage().reference().child("profile_Images").child(result!.user.uid)
            
            if let img = selectedImg {
                let jpegPhoto = img.jpegData(compressionQuality: 0.1)
                storageReference.putData(jpegPhoto!, metadata: nil, completion: { (meta, error) in
                    if error != nil {
                        onFail(error!.localizedDescription)
                        return
                    }
                    
                    storageReference.downloadURL(completion: { (url, error) in
                        guard url != nil else {
                            onFail("Error with image URL")
                            return
                        }
                        userReference.setValue(["username": username, "password": password, "email": email,"imageURL": url!.absoluteString])
                    })
                    onSucess()
                })
            }
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
}
