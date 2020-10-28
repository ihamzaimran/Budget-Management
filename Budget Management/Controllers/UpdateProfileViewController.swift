//
//  UpdateProfileViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import GoogleSignIn

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
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        imagePickerController.delegate = self
        
        setTextFieldBorderColor()
    }
    
    @IBAction func profileImageButton(_ sender: UIButton) {
        self.uiviewPicker.frame = self.view.frame
        self.view.addSubview(uiviewPicker)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveIconButton(_ sender: UIButton) {
        
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
        profileImage.contentMode = .scaleAspectFill
        profileImage.makeRoundedImage()
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}


//MARK:- uitextfieldDelegate

extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxt {
//            GIDSignIn.sharedInstance().presentingViewController = self
//            GIDSignIn.sharedInstance()?.signIn()
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
            dismiss(animated: true, completion: nil)
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
}
