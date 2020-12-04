//
//  UpdateProfileViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import GoogleSignIn
import RealmSwift
import Toast_Swift

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var uiviewPicker: UIView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var selectGenderTxt: UITextField!
    @IBOutlet weak var professionTxt: UITextField!
    @IBOutlet var genderViewPicker: UIView!
    @IBOutlet weak var femaleGenderTxt: UILabel!
    @IBOutlet weak var maleGenderTxt: UILabel!
    @IBOutlet weak var femaleGenderView: UIView!
    @IBOutlet weak var maleGenderView: UIView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var studentView: UIView!
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var professionalView: UIView!
    @IBOutlet weak var professionalImageView: UIImageView!
    @IBOutlet weak var housewifeView: UIView!
    @IBOutlet weak var housewifeImageView: UIImageView!
    @IBOutlet weak var retiredView: UIView!
    @IBOutlet weak var retiredImageView: UIImageView!
    @IBOutlet var professionView: UIView!
    @IBOutlet weak var studentTxt: UILabel!
    @IBOutlet weak var professionaltxt: UILabel!
    @IBOutlet weak var housewifeTxt: UILabel!
    @IBOutlet weak var retiredTxt: UILabel!
    
    private var imagePickerController = UIImagePickerController()
    private let focusedTextFieldColor = UIColor(named: "PrimaryColor")!
    private let realm = try! Realm()
    private var userPickedImage: UIImage?
    private var userId: String?
    private let userDefault = UserDefaults.standard
    private let settingsVC = SettingsViewController()
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //        GIDSignIn.sharedInstance()?.delegate = self
        
        navigationItem.hidesBackButton = true
        imagePickerController.delegate = self
        
        profileImage.contentMode = .scaleAspectFill
        nameTxt.delegate = self
        emailTxt.delegate = self
        mobileTxt.delegate = self
        selectGenderTxt.delegate = self
        professionTxt.delegate = self
        
        setTextFieldBorderColor()
        getDataFromRealm()
        //        registerNotification()
    }
    
    
    // registering notification to know when keyboard appearss
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
    
    //getting data from realm
    private func getDataFromRealm(){
        
        if let userid = userDefault.string(forKey: "UserID")  {
            userId = userid
        } else {
            print("Error! User is not signed in.")
        }
        
        if userId != nil {
            let details = self.realm.objects(ProfileModel.self)
            
            for data in details {
                if let details = self.realm.objects(ProfileModel.self).filter("id = %@", data.id).first {
                    
                    emailTxt.text = details.email
                    nameTxt.text = details.name
                    mobileTxt.text = details.mobile
                    selectGenderTxt.text = details.gender
                    professionTxt.text = details.profession
                    print(details.email)
                    
                    if let image = details.profileImageData {
                        profileImage.image = UIImage(data: image)
                        userPickedImage = UIImage(data: image)
                        profileImage.makeRoundedImage()
                    }
                }
            }
        }
    }
    
    
    @IBAction func profileImageButton(_ sender: UIButton) {
        showPicker(forView: uiviewPicker)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveIconButton(_ sender: UIButton) {
        print("Saving Data...")
        saveData()
    }
    
    @IBAction func gallerButton(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: {
            self.uiviewPicker.removeFromSuperview()
        })
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        self.imagePickerController.sourceType = .camera
        self.imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: {
            self.uiviewPicker.removeFromSuperview()
        })
    }
    
    @IBAction func uiPickerViewCancelButton(_ sender: UIButton) {
        self.uiviewPicker.removeFromSuperview()
    }
    
    @IBAction func selectGenderOKBtn(_ sender: UIButton) {
        
        if femaleGenderView.tag == 1 {
            selectGenderTxt.text = "Female"
        } else if maleGenderView.tag == 1 {
            selectGenderTxt.text = "Male"
        }
        
        removeUIView()
    }
    
    @IBAction func selectGenderCancelBtn(_ sender: UIButton) {
        removeUIView()
    }
    
    @IBAction func prefessionOKBtn(_ sender: UIButton) {
        
        if studentView.tag == 1 {
            professionTxt.text = "Student"
        } else if professionalView.tag == 1 {
            professionTxt.text = "Professional"
        } else if housewifeView.tag == 1 {
            professionTxt.text = "Housewife"
        } else if retiredView.tag == 1 {
            professionTxt.text = "Retired"
        }
        self.professionView.removeFromSuperview()
        
    }
    
    @IBAction func professionCancelBtn(_ sender: UIButton) {
        self.professionView.removeFromSuperview()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    
    // picker view methods
    private func showPicker(forView: UIView){
        forView.frame = self.view.frame
        self.view.addSubview(forView)
    }
    
    private func removeUIView(){
        self.genderViewPicker.removeFromSuperview()
    }
    
    
    //setting custom border color to textfields
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
    
    
    
    // tap gesture recognisers for views
    @IBAction func femaleViewTapGestureRecogniser(_ sender: UITapGestureRecognizer) {
        
        maleGenderTxt.textColor = .darkGray
        femaleGenderTxt.textColor = UIColor(named: "HeaderColor")
        femaleImageView.backgroundColor = UIColor(named: "HeaderColor")
        maleImageView.backgroundColor = nil
        femaleGenderView.tag = 1
        maleGenderView.tag = 0
        print("female")
        //        removeUIView()
    }
    
    @IBAction func maleViewTapGestureRecogniser(_ sender: UITapGestureRecognizer) {
        
        femaleGenderTxt.textColor = .darkGray
        maleGenderTxt.textColor = UIColor(named: "HeaderColor")
        femaleImageView.backgroundColor = nil
        maleImageView.backgroundColor = UIColor(named: "HeaderColor")
        femaleGenderView.tag = 0
        maleGenderView.tag = 1
        print("male")
        //        removeUIView()
    }
    
    @IBAction func studentTapRecogniserView(_ sender: UITapGestureRecognizer) {
        
        studentImageView.image = UIImage(named: "student_selected")
        professionalImageView.image = UIImage(named: "icon_professional")
        housewifeImageView.image = UIImage(named: "icon_housewife")
        retiredImageView.image = UIImage(named: "icon_retired")
        
        studentTxt.textColor = UIColor(named: "HeaderColor")
        professionaltxt.textColor = .darkGray
        housewifeTxt.textColor = .darkGray
        retiredTxt.textColor = .darkGray
        
        studentView.tag = 1
        professionalView.tag = 0
        housewifeView.tag = 0
        retiredView.tag = 0
    }
    
    @IBAction func professionalTapRecogniserView(_ sender: UITapGestureRecognizer) {
        
        studentImageView.image = UIImage(named: "icon_student")
        professionalImageView.image = UIImage(named: "prof_selected")
        housewifeImageView.image = UIImage(named: "icon_housewife")
        retiredImageView.image = UIImage(named: "icon_retired")
        
        studentTxt.textColor = .darkGray
        professionaltxt.textColor = UIColor(named: "HeaderColor")
        housewifeTxt.textColor = .darkGray
        retiredTxt.textColor = .darkGray
        
        studentView.tag = 0
        professionalView.tag = 1
        housewifeView.tag = 0
        retiredView.tag = 0
    }
    
    @IBAction func housewifeTapRecogniserView(_ sender: UITapGestureRecognizer) {
        
        studentImageView.image = UIImage(named: "icon_student")
        professionalImageView.image = UIImage(named: "icon_professional")
        housewifeImageView.image = UIImage(named: "house_selected")
        retiredImageView.image = UIImage(named: "icon_retired")
        
        studentTxt.textColor = .darkGray
        professionaltxt.textColor = .darkGray
        housewifeTxt.textColor = UIColor(named: "HeaderColor")
        retiredTxt.textColor = .darkGray
        
        studentView.tag = 0
        professionalView.tag = 0
        housewifeView.tag = 1
        retiredView.tag = 0
    }
    
    @IBAction func reiredTapRecogniserView(_ sender: UITapGestureRecognizer) {
        
        studentImageView.image = UIImage(named: "icon_student")
        professionalImageView.image = UIImage(named: "icon_professional")
        housewifeImageView.image = UIImage(named: "icon_housewife")
        retiredImageView.image = UIImage(named: "retired_selected")
        
        studentTxt.textColor = .darkGray
        professionaltxt.textColor = .darkGray
        housewifeTxt.textColor = .darkGray
        retiredTxt.textColor = UIColor(named: "HeaderColor")
        
        studentView.tag = 0
        professionalView.tag = 0
        housewifeView.tag = 0
        retiredView.tag = 1
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
        profileImage.contentMode = .scaleAspectFill
        profileImage.makeRoundedImage()
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    //saving data to realm
    private func saveData(){
        
        if let userId = userId {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", userId).first {
                do {
                    try self.realm.write {
                        
                        let imageData = userPickedImage?.jpegData(compressionQuality: 0.2)
                        details.mobile = mobileTxt.text ?? ""
                        details.profileImageData = imageData
                        details.gender = selectGenderTxt.text ?? ""
                        details.profession = professionTxt.text ?? ""
                        print("Data saved successfully!")
                        self.view.makeToast("changes saved successfully", duration: 1.0, position: .bottom)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            self.gotoSettingsVC()
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
    
    private func gotoSettingsVC(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- uitextfieldDelegate

extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxt {
            GIDSignIn.sharedInstance()?.signIn()
            textField.resignFirstResponder()
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == nameTxt{
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == mobileTxt {
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
        } else if textField == selectGenderTxt {
            textField.resignFirstResponder()
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
            showPicker(forView: genderViewPicker)
        } else if textField == professionTxt {
            textField.setTextFieldStyle(with: focusedTextFieldColor, for: 2.0)
            textField.resignFirstResponder()
            showPicker(forView: professionView)
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
//            selectGenderTxt.becomeFirstResponder()
        } else if selectGenderTxt.isFirstResponder {
            //            removeUIView(from: genderViewPicker)
//            professionTxt.becomeFirstResponder()
        } else if professionTxt.isFirstResponder {
//            professionTxt.resignFirstResponder()
        }
        
        return false
    }
}
