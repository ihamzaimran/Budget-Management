//
//  NewGoalViewController.swift
//  Budget Management
//
//  Created by Intern on 06/11/2020.
//

import UIKit
import RealmSwift
import Toast_Swift

class NewGoalViewController: UIViewController {
    
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var amountTXT: UITextField!
    @IBOutlet weak var targetDateTextfield: UITextField!
    @IBOutlet weak var goalDescriptionTextField: UITextField!
    @IBOutlet weak var iconImageView: UIButton!
    @IBOutlet var selectIconView: UIView!
    @IBOutlet weak var selectIconCollectionView: UICollectionView!
    @IBOutlet weak var iconImage: UIButton!
    
    internal var iconName: String?
    internal var goalName :String?
    private let focusedTextFieldColor = UIColor(named: "PrimaryColor")!
    private let datePicker = UIDatePicker()
    private var userID:String?
    private let userDefault = UserDefaults.standard
    private let realm = try! Realm()
    private var iconArray = Constants.Images.iconArray
    private var choosenIcon = "home_icon"
    internal var selectedGoal: GoalDetails?
    private var isEdit = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = goalName {
            goalNameTextField.text = name
            setIcon(with: name)
        }
        
        selectIconCollectionView.delegate = self
        selectIconCollectionView.dataSource = self
        selectIconCollectionView.backgroundColor = .white
        
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
        amountTXT.textColor = UIColor(named: "PrimaryColor")
        goalNameTextField.textColor = .darkGray
        targetDateTextfield.textColor = .darkGray
        goalDescriptionTextField.textColor = .darkGray
        
        if let userId = userDefault.string(forKey: "UserID"){
            userID = userId
        }
        
        if let detail = selectedGoal{
            isEdit = true
            getGoalDetails(with: detail)
        }
        
    }
    
    private func getGoalDetails(with details: GoalDetails){
        amountTXT.text = "\(details.totalGoalAmount)"
        goalNameTextField.text = details.goalName
        targetDateTextfield.text = details.targetDate
        iconImageView.setBackgroundImage(UIImage(named: details.goalIcon), for: .normal)
        iconImage.setBackgroundImage(UIImage(named: details.goalIcon), for: .normal)
        choosenIcon = details.goalIcon
        goalDescriptionTextField.text = details.goalDescription
    }
    
    private func setIcon(with name: String){
        
        switch name {
        case "Home":
            choosenIcon = "home_icon"
        case "Vehicle":
            choosenIcon = "car_icon"
        case "Education":
            choosenIcon = "edu_icon"
        case "Wedding":
            choosenIcon = "wedding"
        case "Emergency Fund":
            choosenIcon = "medical_m"
        case "Holiday Trip":
            choosenIcon = "palm_icon"
        default:
            choosenIcon = "home_icon"
        }
        iconImageView.setBackgroundImage(UIImage(named: choosenIcon), for: .normal)
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveIconButton(_ sender: UIButton) {
        
        if goalNameTextField.text?.isEmpty ?? true || amountTXT.text?.isEmpty ?? true || targetDateTextfield.text?.isEmpty ?? true || goalDescriptionTextField.text?.isEmpty ?? true{
            self.view.makeToast("one of the field is empty", duration: 1.0, position: .bottom)
        } else {
            if let amount = Int(amountTXT.text!) {
                if amount < 1 {
                    self.view.makeToast("goal amount should be greater than 0")
                }else {
                    saveData()
                }
            }else {
                print("floating point number.")
                self.view.makeToast("please enter an integer")
            }
        }
    }
    
    private func saveData(){
        
        if let id = userID {
            if isEdit == false {
                if let details = self.realm.objects(ProfileModel.self).filter("id = %@", id).first{
                    do {
                        try self.realm.write {
                            let newGoal = GoalDetails()
                            newGoal.goalName = goalNameTextField.text ?? "Home"
                            newGoal.goalDescription = goalDescriptionTextField.text ?? "Savings for goal"
                            newGoal.targetDate = targetDateTextfield.text ?? "22/09/2020"
                            newGoal.totalGoalAmount = Int(amountTXT.text!)!
                            newGoal.savedAmount = 0
                            newGoal.goalIcon = choosenIcon
                            details.goalDetails.append(newGoal)
                            print("Details saved successfully!")
                            
                            self.view.makeToast("Goal Saved!", duration: 1.0, position: .bottom)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } catch {
                        print("Error saving new items, \(error.localizedDescription)")
                    }
                }
            } else {
                do {
                    try self.realm.write {
                        if let detail = selectedGoal {
                            let savedAmount = detail.savedAmount
                            let amount = detail.totalGoalAmount
                            let enteredAmount = Int(amountTXT.text!)!
                            
                            if enteredAmount <= savedAmount {
                                detail.totalGoalAmount = enteredAmount
                                detail.savedAmount = enteredAmount
                            } else {
                                detail.totalGoalAmount = Int(amountTXT.text!)!
                            }
                            
                            detail.goalName = goalNameTextField.text ?? "Home"
                            detail.goalDescription = goalDescriptionTextField.text ?? "Savings for goal"
                            detail.targetDate = targetDateTextfield.text ?? "22/09/2020"
                            
                            detail.goalIcon = choosenIcon
                            print("Details saved successfully!")
                            
                            self.view.makeToast("Changes saved successfully!", duration: 1.0, position: .bottom)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.navigationController?.popViewController(animated: true)
                            }

                        }
                    }
                } catch {
                    print("Error saving new items, \(error.localizedDescription)")
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
        
        self.selectIconView.frame = self.view.frame
        self.view.addSubview(selectIconView)
    }
    
    @IBAction func cancelViewButton(_ sender: UIButton) {
        self.selectIconView.removeFromSuperview()
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

//MARK:- extension collectionview delegate

extension NewGoalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        iconArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectIconCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.TableViewIdentifier.newGoalCollectionCellIdentifier, for: indexPath) as! NewGoalIconCollectionViewCell
        cell.backgroundColor = .clear
        
        cell.iconImage.image = UIImage(named: iconArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //setting the collection view cell to have 4 per row
        let collectionCellSize = collectionView.frame.size.width
        return CGSize(width: collectionCellSize/5, height: collectionCellSize/5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let icon = iconArray[indexPath.row]
        iconImageView.setBackgroundImage(UIImage(named: icon), for: .normal)
        choosenIcon = icon
        print(choosenIcon)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectIconView.removeFromSuperview()
        }
    }
}
