//
//  UpdateProfileViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import GoogleSignIn
import RealmSwift

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var uiviewPicker: UIView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var selectGenderTxt: UITextField!
    @IBOutlet weak var professionTxt: UITextField!
    
    private var imagePickerController = UIImagePickerController()
    private let focusedTextFieldColor = UIColor(named: "PrimaryColor")!
    private let realm = try! Realm()
    private var userPickedImage: UIImage?
    private var userEmail: String?
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        imagePickerController.delegate = self
        
        nameTxt.delegate = self
        emailTxt.delegate = self
        mobileTxt.delegate = self
        selectGenderTxt.delegate = self
        professionTxt.delegate = self
        
        setTextFieldBorderColor()
        getDataFromRealm()
        registerNotification()
    }
    
    private func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 200
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 200
        }
    }
    
    private func getDataFromRealm(){
        
        let data = realm.objects(ProfileModel.self)
        
        if ((GIDSignIn.sharedInstance()?.hasPreviousSignIn()) != nil)  {
           print(GIDSignIn.sharedInstance()?.currentUser.profile.email)
            userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        }
        
//        for data in data
//        {
            if let details = self.realm.objects(ProfileModel.self).filter("email = %@", userEmail).first {
                let detail = details.details
                
                for detail in detail {
                    emailTxt.text = userEmail
                    nameTxt.text = detail.name
//                    userEmail = data.email
                    profileImage.image = UIImage(data: detail.profileImageData!)
                    profileImage.makeRoundedImage()
                }
            }
//        }
    }
    
    
    @IBAction func profileImageButton(_ sender: UIButton) {
        self.uiviewPicker.frame = self.view.frame
        self.view.addSubview(uiviewPicker)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveIconButton(_ sender: UIButton) {
        print("Saving Data...")
        saveImage(image: userPickedImage)
    }
    
    @IBAction func gallerButton(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: {
            self.removeUIPickerView()
        })
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        self.imagePickerController.sourceType = .camera
        self.imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: {
            self.removeUIPickerView()
        })
    }
    
    @IBAction func uiPickerViewCancelButton(_ sender: UIButton) {
        removeUIPickerView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeUIPickerView()

        if emailTxt.isFirstResponder {
            emailTxt.resignFirstResponder()
        } else if nameTxt.isFirstResponder {
            nameTxt.resignFirstResponder()
        } else if mobileTxt.isFirstResponder {
            mobileTxt.resignFirstResponder()
        } else if selectGenderTxt.isFirstResponder {
            selectGenderTxt.resignFirstResponder()
        } else if professionTxt.isFirstResponder {
            professionTxt.resignFirstResponder()
        }
    }
    
    private func removeUIPickerView(){
        self.uiviewPicker.removeFromSuperview()
    }
    
    private func setTextFieldBorderColor(){
        
        emailTxt.delegate = self
        nameTxt.delegate = self
        mobileTxt.delegate = self
        selectGenderTxt.delegate = self
        professionTxt.delegate = self
        
        emailTxt.setTextFieldStyle()
        nameTxt.setTextFieldStyle()
        mobileTxt.setTextFieldStyle()
        selectGenderTxt.setTextFieldStyle()
        professionTxt.setTextFieldStyle()
    }
}


//MARK:- extension uiimagepicker controller

extension UpdateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("An unexpected error occured!")
        }
        
        profileImage.image = pickedImage
        userPickedImage = pickedImage
        profileImage.contentMode = .scaleAspectFit
        profileImage.makeRoundedImage()
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    private func saveImage(image: UIImage?){
        
        if let email = userEmail {
            if let details = self.realm.objects(ProfileModel.self).filter("email = %@", email).first {
                do {
                    try self.realm.write {
                        let profileDetails = ProfileDetails()
                        if let image = userPickedImage{
                            let imageData = image.jpegData(compressionQuality: 0.2)
                            profileDetails.profileImageData = imageData
                            details.details.append(profileDetails)
                            print("Image saved successfully!")
                        }
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
        } else {
            print("Not a registered user!")
        }
    }
}


//MARK:- uitextfieldDelegate

extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxt {
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == nameTxt{
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == mobileTxt {
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == selectGenderTxt {
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == professionTxt {
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTxt {
            textField.setTextFieldStyle()
        } else if textField == nameTxt{
            textField.setTextFieldStyle()
        } else if textField == mobileTxt {
            textField.setTextFieldStyle()
        } else if textField == selectGenderTxt {
            textField.setTextFieldStyle()
        } else if textField == professionTxt {
            textField.setTextFieldStyle()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if nameTxt.isFirstResponder {
            emailTxt.becomeFirstResponder()
        } else if emailTxt.isFirstResponder {
            mobileTxt.becomeFirstResponder()
        } else if mobileTxt.isFirstResponder {
            selectGenderTxt.becomeFirstResponder()
        } else if selectGenderTxt.isFirstResponder {
            professionTxt.becomeFirstResponder()
        } else if professionTxt.isFirstResponder {
            professionTxt.resignFirstResponder()
        }
        
        return false
    }
}
