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
    @IBOutlet weak var saveDeleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    internal var selectedGoalDetails: GoalDetails?
    internal var selectedAchievedGoalDetails: GoalAchieved?
    internal var selectGoalTransaction: GoalDetails?
    internal var edit: Bool?
    private var accountType = "Cash"
    private let relam = try! Realm()
    private let greenColor = UIColor(named: "PrimaryColor")!
    private let redColor = UIColor.systemRed
    private let datePicker = UIDatePicker()
    private typealias todaysDate = (month: String, day: String, year: String)
    private var accounts = List<AccountDetails>()
    private var userID: String?
    private let userDefault = UserDefaults.standard
    private var accountDetail: AccountDetails?
    
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
        addAmountTextField.textColor = greenColor
        addAmountTextField.textFieldStyle(color: .clear)
        
        dateTextField.textFieldStyle(color: .darkGray)
        dateTextField.textColor = .darkGray
        
        depositTypeTextField.textFieldStyle(color: .darkGray)
        depositTypeTextField.textColor = .darkGray
        
        descripitonTextField.textFieldStyle(color: .darkGray)
        descripitonTextField.textColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userID = userDefault.string(forKey: "UserID")
        getDetails()
    }
    
    private func getDetails(){
        
        if let details = selectedGoalDetails, let _ = edit {
            saveDeleteButton.isHidden = false
            saveDeleteButton.tag = 0
            saveDeleteButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalAmounLBL.text = "Goal: \(details.totalGoalAmount)"
            savedAmountLBL.text = "Saved: \(details.savedAmount)"
            descripitonTextField.text = details.goalDescription
            dateTextField.text = details.targetDate
            depositTypeTextField.text = details.accountType
            remainingAmountLBL.text = "Remaining: \(details.totalGoalAmount-details.savedAmount)"
            
        } else if let details = selectedAchievedGoalDetails {
            
            saveDeleteButton.tag = 1
            saveDeleteButton.isHidden = true
            
            addAmountTextField.isUserInteractionEnabled = false
            dateTextField.isUserInteractionEnabled = false
            descripitonTextField.isUserInteractionEnabled = false
            depositTypeTextField.isUserInteractionEnabled = false
            
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalAmounLBL.text = "Goal: \(details.totalGoalAmount)"
            savedAmountLBL.text = "Saved: \(details.totalGoalAmount)"
            addAmountTextField.text = ("\(details.totalGoalAmount)")
            descripitonTextField.text = details.goalDescription
            dateTextField.text = details.targetDate
            depositTypeTextField.text = details.accountType
            remainingAmountLBL.text = "Remaining: \(details.totalGoalAmount-details.totalGoalAmount)"
          
        } else if let details = selectGoalTransaction, let _ = edit {
            saveDeleteButton.tag = 1
            saveDeleteButton.isHidden = true
            
            addAmountTextField.isUserInteractionEnabled = false
            dateTextField.isUserInteractionEnabled = false
            descripitonTextField.isUserInteractionEnabled = false
            depositTypeTextField.isUserInteractionEnabled = false
            
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalAmounLBL.text = "Goal: \(details.totalGoalAmount)"
            savedAmountLBL.text = "Saved: \(details.totalGoalAmount)"
            addAmountTextField.text = ("\(details.totalGoalAmount)")
            descripitonTextField.text = details.goalDescription
            dateTextField.text = details.targetDate
            depositTypeTextField.text = details.accountType
            remainingAmountLBL.text = "Remaining: \(details.totalGoalAmount-details.totalGoalAmount)"
            
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
                    let transactions = GoalTransactions()
                    details.accountType = accountType
                    let amount = Int(addAmountTextField.text!)!
                    details.lastAddedSavingAmount = amount
                    details.savedAmount = details.savedAmount + amount
                    details.targetDate = dateTextField.text!
                    details.goalDescription = descripitonTextField.text!
                    transactions.amount = amount
                    transactions.goalName = details.goalName
                    transactions.goalDescription = details.goalDescription
                    let date = getCurrentDate()
                    transactions.date = "\(date.month)\n\(date.day)\n\(date.year)"
                    details.goalTransactions.append(transactions)
                    
                    if let id = userID {
                        if let profile = self.relam.objects(ProfileModel.self).filter("id = %@", id).first {
                            profile.totalBalance -= Int(addAmountTextField.text!)!
                        }
                    }
                    
                    if let account = accountDetail {
                        account.balance -= Int(addAmountTextField.text!)!
                    } 
                    print("Details updated successfully.")
                    self.view.makeToast("details updated!", duration: 1.0, position: .bottom)
                    dismissController()
                }
            } catch {
                print("Error Savings Details.\n\(error)")
            }
        }
    }
    
    private func getCurrentDate()-> todaysDate{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E-dd-yyyy"
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        
        let curDate: todaysDate = (month: month, day: day, year: year)
        return curDate
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
        
        if saveDeleteButton.tag == 0 {
            checkTextFieldErrors()
            print("saving...")
        } else if saveDeleteButton.tag == 1 {
            //            deleteSavings
            print("deleting....")
        }
    }
    
    private func checkTextFieldErrors(){
        if addAmountTextField.text?.isEmpty ?? true || dateTextField.text?.isEmpty ?? true || depositTypeTextField.text?.isEmpty ?? true || descripitonTextField.text?.isEmpty ?? true{
            self.view.makeToast("one of the field is empty", duration: 1.5, position: .bottom)
        }else {
            
            if let details = selectedGoalDetails{
                
                if let amount = Int(addAmountTextField.text!){
                    let remaining = details.totalGoalAmount-details.savedAmount
                    if amount < 1 {
                        self.view.makeToast("amount should be greater than 0")
                    } else {
                        if amount > remaining {
                            self.view.makeToast("entered amount should be less than the remaining amount!\nremaining goal amount is \(remaining)")
                        } else {
                            saveData()
                        }
                    }
                } else {
                    self.view.makeToast("please enter an integer")
                    print("floating point number.")
                }
            }
        }
    }
    
    @IBAction func selectAccountTypeViewCloseBtn(_ sender: UIButton) {
        self.selectAccountTypeView.removeFromSuperview()
    }
    
    
    @IBAction func addAccountBtn(_ sender: UIButton) {
        let addAccount = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addAccount) as! AddAccountViewController
        self.navigationController?.pushViewController(addAccount, animated: true)
    }
    
    
    private func dismissSelectAccountView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.selectAccountTypeView.removeFromSuperview()
        }
    }
    
    private func showPicker(forView: UIView){
        
        if let userid = userID {
            if let details = relam.objects(ProfileModel.self).filter("id = %@", userid).first {
                accounts = details.accountDetails
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .clear
        
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
        } else if textField == dateTextField {
            showDatePicker()
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

//MARK: - extension datepciker

extension AddSavingAmountViewController {
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
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}


//MARK:- extension tableview delegate

extension AddSavingAmountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.addAccountTableCellIdentifier, for: indexPath) as! AddAccountTableViewCell
        cell.backgroundColor = .clear
        
        cell.imageIcon.makeRoundedImage()
        cell.imageIcon.backgroundColor = UIColor(named: "BackgroundGrayColor")
        let details = accounts[indexPath.row]
        
        if details.balance > 0 {
            cell.balanceLBL.text = ("\(details.balance)")
            cell.balanceLBL.textColor = UIColor(named: "PrimaryColor")
        } else {
            cell.balanceLBL.text = ("\(details.balance)")
            cell.balanceLBL.textColor = .systemRed
        }
        cell.imageIcon.image = UIImage(named: details.icon)
        cell.titleLBL.text = details.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let details = accounts[indexPath.row]
        depositTypeTextField.text = details.name
        tableView.deselectRow(at: indexPath, animated: true)
        accountDetail = details
        dismissSelectAccountView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}
