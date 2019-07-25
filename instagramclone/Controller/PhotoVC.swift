//
//  PhotoVC.swift
//  instagramclone
//
//  Created by MISHAL ALHAJRI on 20/11/1440 AH.
//  Copyright © 1440 Torch. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class PhotoVC: UIViewController{
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    var selectedImg : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.delegate = self
        captionTextView.text = "Please write a nice caption"
        captionTextView.textColor = UIColor.gray
        postImage.layer.cornerRadius = postImage.frame.size.width / 4
        postImage.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(postImgTapped))
        postImage.addGestureRecognizer(gesture)
        postImage.isUserInteractionEnabled = true
        
    }
    
    
    func clean() {
        self.selectedImg = nil
        self.postImage.image = UIImage(named: "placeholder-photo")
        self.captionTextView.text = ""
    }
    @IBAction func RemoveTapped(_ sender: Any) {
        clean()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func postImgTapped() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        present(pickerController,animated: true,completion: nil)
    }
    @IBAction func postButton(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Posting")
        let text = captionTextView!.text!
        let ref = Database.database().reference().child("posts").childByAutoId()
        let storageReference = Storage.storage().reference().child("posts").child(ref.childByAutoId().key!)

        if let theImg = selectedImg {
            let jpegPhoto = theImg.jpegData(compressionQuality: 0.1)
            storageReference.putData(jpegPhoto!, metadata: nil) { (meta, err) in
                if err != nil {
                    print("Some error happend in put data")
                    return
                }
                
                storageReference.downloadURL(completion: { (url, err) in
                    guard let _ = url else {
                        print("Some error happend in put data")
                        return
                    }
                    
                    ref.setValue(["caption: ": self.captionTextView.text!, "postURL": url!.absoluteString])
                            SVProgressHUD.showSuccess(withStatus: "Posted")
                    
                   self.clean()
                    self.tabBarController?.selectedIndex = 0
                })
            }
        }
    }
    

}

extension PhotoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImg = image
            postImage.image = image
        }

        dismiss(animated: false, completion: nil)
    }
    
}

extension PhotoVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.captionTextView.textColor == UIColor.gray {
            self.captionTextView.text = nil
            self.captionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.captionTextView.text.isEmpty {
            self.captionTextView.text = "Please write a nice caption"
            self.captionTextView.textColor = UIColor.gray
        }
    }
}

