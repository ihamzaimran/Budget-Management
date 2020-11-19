//
//  AddAccountViewController.swift
//  Budget Management
//
//  Created by Intern on 18/11/2020.
//

import UIKit
import DropDown
import Toast_Swift
import RealmSwift

class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var bankNameTXT: UITextField!
    @IBOutlet weak var openingBalanceTXT: UITextField!
    @IBOutlet weak var accountTypeTXT: UITextField!
    @IBOutlet weak var negativeBalanceSwitch: UISwitch!
    @IBOutlet weak var pintoDashboardSwitch: UISwitch!
    @IBOutlet weak var selectColorView: UIView!
    @IBOutlet weak var selectIconView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let dropDown = DropDown()
    private let colorDropDown = DropDown()
    private let iconDropDown = DropDown()
    private var negativeBalanceState = false
    private var pintoDashboardState = false
    private var iconName = "salary"
    private var colorName = "#008577"
    private var userID: String?
    private var userDefault = UserDefaults.standard
    private let realm = try! Realm()
    internal var edit = false
    internal var isSelectedAccount: AccountDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bankNameTXT.delegate = self
        openingBalanceTXT.delegate = self
        accountTypeTXT.delegate = self
        
        bankNameTXT.textFieldStyle(color: .darkGray)
        openingBalanceTXT.textFieldStyle(color: .darkGray)
        accountTypeTXT.textFieldStyle(color: .darkGray)
        
        bankNameTXT.textColor = .darkGray
        openingBalanceTXT.textColor = .darkGray
        accountTypeTXT.textColor = .darkGray
        
        userID = userDefault.string(forKey: "UserID")
        getDetails()
        
        if negativeBalanceSwitch.isOn {
            negativeBalanceState = true
        } else {
            negativeBalanceState = false
        }
        
        if pintoDashboardSwitch.isOn {
            pintoDashboardState = true
        } else {
            pintoDashboardState = false
        }
        
    }
    
    
    private func getDetails() {
        if let details = isSelectedAccount{
            if edit == true {
                deleteButton.isHidden = false
                bankNameTXT.text = details.name
                openingBalanceTXT.text = "\(details.balance)"
                accountTypeTXT.text = details.type
                
                if details.isNegtaiveBalance {
                    negativeBalanceSwitch.setOn(true, animated: true)
                } else {
                    negativeBalanceSwitch.setOn(false, animated: true)
                }
                
                if details.isPinToDashboard {
                    pintoDashboardSwitch.setOn(true, animated: true)
                } else {
                    pintoDashboardSwitch.setOn(false, animated: true)
                }
                
                colorView.backgroundColor = hexStringToUIColor(hex: details.colorHexString)
                iconImage.image = UIImage(named: details.icon)
            }
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAccountTypeDropDownMenu() {
        
        dropDown.dataSource = ["Person/Other", "Cash", "Bank"]
        dropDown.anchorView = accountTypeTXT
        dropDown.bottomOffset = CGPoint(x: 0, y: accountTypeTXT.frame.height)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            
            switch item {
            case "Person/Other":
                self?.accountTypeTXT.text = item
            case "Cash":
                self?.accountTypeTXT.text = item
            case "Bank":
                self?.accountTypeTXT.text = item
            default:
                print("item not found")
                break
            }
        }
        dropDown.show()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if bankNameTXT.isFirstResponder {
            bankNameTXT.resignFirstResponder()
        }else if accountTypeTXT.isFirstResponder {
            accountTypeTXT.resignFirstResponder()
        }else if openingBalanceTXT.isFirstResponder {
            openingBalanceTXT.resignFirstResponder()
        }
    }
    
    @IBAction func switchBtn(_ sender: UISwitch) {
        
        if sender == negativeBalanceSwitch {
            if negativeBalanceSwitch.isOn {
                negativeBalanceSwitch.setOn(true, animated: true)
                negativeBalanceState = true
            } else {
                negativeBalanceSwitch.setOn(false, animated: true)
                negativeBalanceState = false
            }
        } else if sender == pintoDashboardSwitch {
            if pintoDashboardSwitch.isOn {
                pintoDashboardState = true
                pintoDashboardSwitch.setOn(true, animated: true)
            } else {
                pintoDashboardState = false
                pintoDashboardSwitch.setOn(false, animated: true)
            }
        }
    }
    
    @IBAction func selectColorViewBtn(_ sender: UIButton) {
        
        colorDropDown.dataSource = Constants.Colors.colorString
        colorDropDown.anchorView = selectColorView
        colorDropDown.bottomOffset = CGPoint(x: 0, y: selectColorView.frame.height)
        colorDropDown.width = 150
        colorDropDown.direction = .bottom
        
        colorDropDown.cellNib = UINib(nibName: "SelectColorCell", bundle: nil)
        colorDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            guard let cell = cell as? SelectColorCell else { return }
            
            // Setup your custom UI components
            let color = self.hexStringToUIColor(hex: item)
            cell.colorView.backgroundColor = color
        }
        
        colorDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            
            self?.colorName = item
            self?.colorView.backgroundColor = self?.hexStringToUIColor(hex: item)
        }
        
        colorDropDown.show()
    }
    
    @IBAction func selectIconViewBtn(_ sender: UIButton) {
        
        iconDropDown.dataSource = Constants.Images.iconArray
        iconDropDown.anchorView = selectIconView
        iconDropDown.bottomOffset = CGPoint(x: 0, y: selectIconView.frame.height)
        iconDropDown.width = 150
        
        iconDropDown.direction = .bottom
        
        iconDropDown.cellNib = UINib(nibName: "SelectIconCell", bundle: nil)
        iconDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SelectIconCell else { return }
            
            // Setup your custom UI components
            cell.iconImage.image = UIImage(named: item)
        }
        
        iconDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            
            self?.iconImage.image = UIImage(named: item)
            self?.iconName = item
        }
        
        iconDropDown.show()
    }
    
    @IBAction func saveAccountDetailsBtn(_ sender: UIButton) {
        
        if accountTypeTXT.text?.isEmpty ?? true || bankNameTXT.text?.isEmpty ?? true || openingBalanceTXT.text?.isEmpty ?? true {
            print("one the field is empty.")
            self.view.makeToast("one of the textfield is empty.")
        } else {
            if let amount = Int(openingBalanceTXT.text!) {
                if amount < 1 {
                    self.view.makeToast("opening amount should be greater than 0")
                }else {
                    
                    if let account = isSelectedAccount {
                        if edit == true {
                            saveEditedData()
                        }
                    } else {
                        saveData()
                    }
                    
                }
            }else {
                print("floating point number not allowed.")
                self.view.makeToast("please enter an integer")
            }
        }
    }
    
    @IBAction func deleteIcon(_ sender: UIButton) {
        
        if let account = isSelectedAccount {
            do {
                try self.realm.write {
                    realm.delete(account)
                    self.view.makeToast("account deleted!", duration: 1.0, position: .bottom)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                self.view.makeToast("An error occured!")
                print(error.localizedDescription)
            }
        } else {
            print("error occured!")
        }
    }
    
    private func saveEditedData() {
        
        if let account = isSelectedAccount {
            do {
                try self.realm.write {
                    
                    account.colorHexString = colorName
                    account.icon = iconName
                    account.isNegtaiveBalance = negativeBalanceState
                    account.isPinToDashboard = pintoDashboardState
                    account.name = bankNameTXT.text!
                    account.type = accountTypeTXT.text!
                    
                    if negativeBalanceState == true {
                        account.balance = -Int(openingBalanceTXT.text!)!
//                        details.totalBalance += (-Int(openingBalanceTXT.text!)!)
                    } else {
                        account.balance = Int(openingBalanceTXT.text!)!
//                        details.totalBalance += (Int(openingBalanceTXT.text!)!)
                    }
                    
                    print("Account edited successfully!")
                    
                    self.view.makeToast("Account Edited successfully", duration: 1.0, position: .bottom)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Error editing new items, \(error.localizedDescription)")
            }
        }
    }
    
    private func saveData(){
        if let id = userID {
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", id).first{
                do {
                    try self.realm.write {
                        
                        let newAccount = AccountDetails()
                        
                        newAccount.colorHexString = colorName
                        newAccount.icon = iconName
                        newAccount.isNegtaiveBalance = negativeBalanceState
                        newAccount.isPinToDashboard = pintoDashboardState
                        newAccount.name = bankNameTXT.text!
                        newAccount.type = accountTypeTXT.text!
                        details.accountDetails.append(newAccount)
                        
                        if negativeBalanceState == true {
                            newAccount.balance = -Int(openingBalanceTXT.text!)!
                            details.totalBalance += (-Int(openingBalanceTXT.text!)!)
                        } else {
                            newAccount.balance = Int(openingBalanceTXT.text!)!
                            details.totalBalance += (Int(openingBalanceTXT.text!)!)
                        }
                        
                        print("Account saved successfully!")
                        
                        self.view.makeToast("Account Saved successfully", duration: 1.0, position: .bottom)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    print("Error saving new items, \(error.localizedDescription)")
                }
            }
        }
        
    }
    
}


//MARK:- extension textfielddelegate

extension AddAccountViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == accountTypeTXT{
            bankNameTXT.resignFirstResponder()
            openingBalanceTXT.resignFirstResponder()
            textField.resignFirstResponder()
            showAccountTypeDropDownMenu()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == accountTypeTXT {
            textField.resignFirstResponder()
        } else if textField == bankNameTXT {
            textField.resignFirstResponder()
        } else if textField == openingBalanceTXT {
            textField.resignFirstResponder()
        }
        
        return false
    }
}

//MARK:- extension hexString to uicolor

extension UIViewController{
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
