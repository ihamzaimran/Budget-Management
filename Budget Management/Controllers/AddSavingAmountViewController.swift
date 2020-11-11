//
//  AddSavingAmountViewController.swift
//  Budget Management
//
//  Created by Intern on 10/11/2020.
//

import UIKit
import RealmSwift

class AddSavingAmountViewController: UIViewController {
    
    @IBOutlet weak var goalNameLBL: UILabel!
    @IBOutlet weak var targetDateLBL: UILabel!
    @IBOutlet weak var goalAmounLBL: UILabel!
    @IBOutlet weak var savedAmountLBL: UILabel!
    @IBOutlet weak var remainingAmountLBL: UILabel!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var addAmountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var depositTypeTextField: UITextField!
    @IBOutlet weak var descripitonTextField: UITextField!
    @IBOutlet var selectAccountTypeView: UIView!
    @IBOutlet weak var cashViewImage: UIView!
    @IBOutlet weak var bankViewImage: UIView!
    @IBOutlet weak var otherViewImage: UIView!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var bankBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    internal var selectedGoalDetails: GoalDetails?
    private var accountType = "Cash"
    private let relam = try! Realm()
    private let greenColor = UIColor(named: "PrimaryColor")!
    private let redColor = UIColor.systemRed
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAmountTextField.delegate = self
        dateTextField.delegate = self
        depositTypeTextField.delegate = self
        descripitonTextField.delegate = self
        
        addAmountTextField.text = nil
        addAmountTextField.textAlignment = .right
        addAmountTextField.textColor = .darkGray
        changeBorderColor(name: greenColor)
        
        dateTextField.textFieldStyle(color: .darkGray)
        dateTextField.textColor = .darkGray
        
        depositTypeTextField.textFieldStyle(color: .darkGray)
        depositTypeTextField.textColor = .darkGray
        
        descripitonTextField.textFieldStyle(color: .darkGray)
        descripitonTextField.textColor = .darkGray
        
        cashViewImage.makeRoundedView()
        bankViewImage.makeRoundedView()
        otherViewImage.makeRoundedView()
        
        getDetails()
    }
    
    private func getDetails(){
        
        if let details = selectedGoalDetails {
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalAmounLBL.text = "Goal: \(details.totalGoalAmount)"
            savedAmountLBL.text = "Saved: \(details.savedAmount)"
            descripitonTextField.text = details.goalDescription
            dateTextField.text = details.targetDate
            depositTypeTextField.text = details.accountType
            if let total = Int(details.totalGoalAmount) {
                remainingAmountLBL.text = "Remaining: \(total-details.savedAmount)"
            } else {
                remainingAmountLBL.text = "Remaining: N/A"
            }
            
            if cashBtn.tag == 1 {
                cashViewImage.backgroundColor = .lightGray
            } else if bankViewImage.tag == 1 {
                bankViewImage.backgroundColor = .lightGray
            } else if otherViewImage.tag == 1 {
                otherViewImage.backgroundColor = .lightGray
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if addAmountTextField.isFirstResponder {
            addAmountTextField.resignFirstResponder()
        } else if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        } else if depositTypeTextField.isFirstResponder {
            depositTypeTextField.resignFirstResponder()
        } else if descripitonTextField.isFirstResponder {
            descripitonTextField.resignFirstResponder()
        }
    }
    
    private func saveData(){
        if let details = selectedGoalDetails {
            do {
                try self.relam.write {
                    details.accountType = accountType
                    let amount = Int(addAmountTextField.text!)!
                    details.savedAmount = amount
                    print("Details updated successfully.")
                    self.view.makeToast("details updated!", duration: 1.0, position: .bottom)
                    dismissController()
                }
            } catch {
                print("Error Savings Details.\n\(error)")
            }
        }
    }
    
    private func changeBorderColor(name: UIColor) {
        addAmountTextField.layer.borderColor = name.cgColor
        addAmountTextField.layer.borderWidth = 1.0
        addAmountTextField.layer.cornerRadius = 5.0
    }
    
    private func dismissController(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveDepositBtn(_ sender: UIButton) {
        
        if addAmountTextField.text?.isEmpty ?? true {
            changeBorderColor(name: redColor)
            self.view.makeToast("amount field cannot be empty", duration: 1.5, position: .bottom)
        } else {
            saveData()
        }
    }
    
    @IBAction func selectAccountTypeViewCloseBtn(_ sender: UIButton) {
        self.selectAccountTypeView.removeFromSuperview()
    }
    
    @IBAction func chosenAccountBtn(_ sender: UIButton) {
        
        if sender == cashBtn {
            
            cashBtn.tag = 1
            bankBtn.tag = 0
            otherBtn.tag = 0
            accountType = "Cash"
            cashViewImage.backgroundColor = .lightGray
            bankViewImage.backgroundColor = nil
            otherViewImage.backgroundColor = nil
            dismissSelectAccountView()
        } else if sender == bankBtn {
            
            cashBtn.tag = 0
            bankBtn.tag = 1
            otherBtn.tag = 0
            accountType = "Bank"
            cashViewImage.backgroundColor = nil
            bankViewImage.backgroundColor = .lightGray
            otherViewImage.backgroundColor = nil
            dismissSelectAccountView()
        } else if sender == otherBtn {
            
            cashBtn.tag = 0
            bankBtn.tag = 0
            otherBtn.tag = 1
            accountType = "Other"
            cashViewImage.backgroundColor = nil
            bankViewImage.backgroundColor = nil
            otherViewImage.backgroundColor = .lightGray
            dismissSelectAccountView()
        }
    }
    
    private func dismissSelectAccountView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.depositTypeTextField.text = self.accountType
            self.selectAccountTypeView.removeFromSuperview()
        }
    }
    
    private func showPicker(forView: UIView){
        forView.frame = self.view.frame
        self.view.addSubview(forView)
    }
}


//MARK:- extension textfield delegate

extension AddSavingAmountViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addAmountTextField {
            changeBorderColor(name: greenColor)
        } else if textField == depositTypeTextField {
            textField.resignFirstResponder()
            self.showPicker(forView: selectAccountTypeView)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if addAmountTextField.isFirstResponder {
            addAmountTextField.resignFirstResponder()
        } else if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        } else if depositTypeTextField.isFirstResponder {
            depositTypeTextField.resignFirstResponder()
        } else if descripitonTextField.isFirstResponder {
            descripitonTextField.resignFirstResponder()
        }
        return false
    }
}
