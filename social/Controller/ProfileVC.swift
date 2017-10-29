//
//  UserVC.swift
//  social
//
//  Created by Jaroslavs Rogacs on 29/10/2017.
//  Copyright © 2017 UTGARD.io. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var birthField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    let ds = DataService.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        ds.REF_USER_CURRENT.getDocument { (document, error) in
            if let document = document {
                let key = document.documentID
                let user = User.init(userKey: key, userData: document.data())
                self.nameField.text = user.name
                self.bioField.text = user.bio
                self.birthField.text = user.birth
            } else {
                print("PROFILEVC: User data does not exist")
            }
        }
    }
    
    @IBAction func addImageButton(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("PROFILEVC: A valid image was not selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backToFeed", sender: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        guard let name = nameField.text else {
            print("PROFILEVC: Name must be entered")
            return
        }
        guard let image = addImage.image, imageSelected == true else {
            print("PROFILEVC: Image must be entered")
            return
        }
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            ds.STORAGE.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("PROFILEVC: Unable to upload image to Firebase storage.")
                } else {
                    print("PROFILEVC: Successfully uploaded to Firebase storage.")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: downloadURL!)
                        print(url)
                    }
                }
            }
        }
        
        performSegue(withIdentifier: "backToFeed", sender: nil)
    }
    
    func postToFirebase(imgUrl: String) {
        let ref = ds.REF_USER_CURRENT
        let image: Dictionary<String, Any> = [
            "name": NSUUID().uuidString,
            "url": imgUrl,
            "date": Date()
        ]
        let firebaseImage = ds.REF_IMAGES.addDocument(data: image)
        
        let user: Dictionary<String, Any> = [
            "uid": ref.documentID,
            "date": Date(),
            "name": nameField.text as Any,
            "avatar": firebaseImage.documentID,
            "bio": bioField.text as Any,
            "birth": birthField.text as Any
        ]
        // update per keychain
        ref.updateData(user)
        
        imageSelected = false
        nameField.text = ""
        bioField.text = ""
        birthField.text = ""
        addImage.image = UIImage(named: "icon-add-image")
    }
}
