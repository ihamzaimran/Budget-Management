//
//  NewGoalViewController.swift
//  Budget Management
//
//  Created by Intern on 06/11/2020.
//

import UIKit
import RealmSwift

class NewGoalViewController: UIViewController {
    
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var amountTXT: UITextField!
    @IBOutlet weak var targetDateTextfield: UITextField!
    @IBOutlet weak var goalDescriptionTextField: UITextField!
    @IBOutlet weak var iconImageView: UIButton!
    
    internal var iconName: String?
    internal var goalName :String?
    private let focusedTextFieldColor = UIColor(named: "PrimaryColor")!
    private let datePicker = UIDatePicker()
    private var userID:String?
    private let userDefault = UserDefaults.standard
    private let realm = try! Realm()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let icon = iconName, let name = goalName {
            print(icon)
            goalNameTextField.text = name
        }
        
        goalNameTextField.delegate = self
        amountTXT.delegate = self
        targetDateTextfield.delegate = self
        goalDescriptionTextField.delegate = self
        
        goalNameTextField.textFieldStyle(color: .darkGray)
        targetDateTextfield.textFieldStyle(color: .darkGray)
        goalDescriptionTextField.textFieldStyle(color: .darkGray)
        amountTXT.textFieldStyle(color: .clear)
        amountTXT.text = nil 
        amountTXT.textAlignment = .right
        amountTXT.textColor = .darkGray
        goalNameTextField.textColor = .darkGray
        targetDateTextfield.textColor = .darkGray
        goalDescriptionTextField.textColor = .darkGray
        
        if let userId = userDefault.string(forKey: "UserID"){
            userID = userId
        }
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveIconButton(_ sender: UIButton) {
        if let id = userID {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", id).first{
                do {
                    try self.realm.write {
                        let newGoal = GoalDetails()
                        newGoal.goalName = goalNameTextField.text ?? "Home"
                        newGoal.goalDescription = goalDescriptionTextField.text ?? "Savings for goal"
                        newGoal.targetDate = targetDateTextfield.text ?? "22/09/2020"
                        newGoal.goalAmount = "20000"
                        details.goalDetails.append(newGoal)
                        print("Details saved successfully!")
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if amountTXT.isFirstResponder {
            amountTXT.resignFirstResponder()
        } else if goalNameTextField.isFirstResponder {
            goalNameTextField.resignFirstResponder()
        } else if goalDescriptionTextField.isFirstResponder{
            goalDescriptionTextField.resignFirstResponder()
        }
    }
    
    @IBAction func selectIconViewTapped(_ sender: UIButton) {
        print("tap gesture tapped!")
        iconImageView.setBackgroundImage(UIImage(named: Constants.Images.iconArray[0]), for: .normal)
    }
    
}


//MARK:- extension texfield delegate

extension NewGoalViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        goalNameTextField.textFieldStyle(color: focusedTextFieldColor)
        
        if textField == targetDateTextfield {
            showDatePicker()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        goalNameTextField.textFieldStyle(color: .darkGray)
        goalDescriptionTextField.textFieldStyle(color: .darkGray)
        amountTXT.textFieldStyle(color: .clear)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if amountTXT.isFirstResponder {
            goalNameTextField.becomeFirstResponder()
        } else if goalNameTextField.isFirstResponder {
            targetDateTextfield.becomeFirstResponder()
        } else if targetDateTextfield.isFirstResponder {
            goalDescriptionTextField.becomeFirstResponder()
        } else if goalDescriptionTextField.isFirstResponder {
            goalDescriptionTextField.resignFirstResponder()
        }
        return false
    }
}


//MARK: - extension datepciker

extension NewGoalViewController {
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //ToolBar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-200, width: UIScreen.main.bounds.width, height: 44))
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        targetDateTextfield.inputAccessoryView = toolbar
        targetDateTextfield.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        targetDateTextfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

