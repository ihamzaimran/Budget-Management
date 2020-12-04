//
//  EditMonthlyBudgetViewController.swift
//  Budget Management
//
//  Created by Intern on 02/12/2020.
//

import UIKit
import RealmSwift
import Toast_Swift

class EditMonthlyBudgetViewController: UIViewController {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var descLBL: UILabel!
    @IBOutlet weak var amountTxt: UITextField!
    
    internal var titleText: String?
    internal var imageIcon: String?
    internal var index: Int?
    private let realm = try! Realm()
    private let userDefault = UserDefaults.standard
    private var userID: String?
    private var budget:Results<Budget>?
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTxt.setTextFieldStyle()
        amountTxt.delegate = self
        
        userID = userDefault.string(forKey: "UserID")
        
        if let icon = imageIcon, let text = titleText, let index = index {
            titleLBL.text = text
            titleImage.image = UIImage(named: icon)
            getDetails(for: index)
        }
    }
    
    
    //getting details from realm
    private func getDetails(for index: Int){
        
        if let id = userID {
            if self.realm.objects(ProfileModel.self).filter("id = %@", id).first != nil {
                budget = self.realm.objects(Budget.self)
                
                if let indexOutofBoundCheck = budget?.count {
                    if index >= indexOutofBoundCheck {
                        print("Budget not defined.")
                    } else {
                        if let budget = budget?[index]{
                            if budget.totalAmount <= 0 {
                                descLBL.text = "No Budget is defined for this month."
                            } else {
                                amountTxt.text = "\(budget.totalAmount)"
                                descLBL.text = "Budget for this month is \(budget.totalAmount)"
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
    // saving details to realm
    private func saveDetails() {
        if let id = userID{
            if let profile = self.realm.objects(ProfileModel.self).filter("id = %@", id).first {
                if let amount = Int(amountTxt.text!) {
                    do {
                        try self.realm.write{
                            let newBudget = Budget()
                            newBudget.totalAmount = amount
                            
                            print("budget saved successfully!")
                            self.view.makeToast("Successfully Saved!")
                            profile.budgetsList.append(newBudget)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                        self.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func backIcon(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneIconPressed(_ sender: UIButton) {
        if amountTxt.text?.isEmpty ?? true {
            print("textfield is empty")
            self.view.makeToast("amount cannot be empty")
        }else {
            if let amount = Int(amountTxt.text!){
                if amount <= 0 {
                    self.view.makeToast("amount cannot be less than 0")
                } else {
                    saveDetails()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if amountTxt.isFirstResponder {
            amountTxt.resignFirstResponder()
        }
    }
}

//MARK:- extension textfield delegate

extension EditMonthlyBudgetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder{
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        amountTxt.setTextFieldStyle(with: UIColor(named: "PrimaryColor")!, for: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        amountTxt.setTextFieldStyle()
    }
}
