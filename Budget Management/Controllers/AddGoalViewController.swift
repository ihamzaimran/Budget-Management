//
//  AddGoalViewController.swift
//  Budget Management
//
//  Created by Intern on 06/11/2020.
//

import UIKit

class AddGoalViewController: UIViewController {
    
    @IBOutlet weak var goalNameTxt: UITextField!
    
    private let focusedTextFieldColor = UIColor(named: "PrimaryColor")!
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalNameTxt.delegate = self
        goalNameTxt.textFieldStyle(color: .darkGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goalNameTxt.text = nil
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createGoalButton(_ sender: UIButton) {
        
        var icon = "home"
        let goalName = goalNameTxt.text
        
        if sender.tag == 0 {
            if goalName?.isEmpty ?? true {
                self.view.makeToast("add goal name", duration: 2.0, position: .bottom)
            } else {
                icon = "home"
                goToNewGoalVC(with: goalName!, and: icon)
            }
        } else if sender.tag == 1{
            icon = "home"
            goToNewGoalVC(with: "Home", and: icon)
        } else if sender.tag == 2{
            icon = "vehicle"
            goToNewGoalVC(with: "Vehicle", and: icon)
        } else if sender.tag == 3{
            icon =  "education"
            goToNewGoalVC(with: "Education", and: icon)
        } else if sender.tag == 4{
            icon = "wedding"
            goToNewGoalVC(with: "Wedding", and: icon)
        } else if sender.tag == 5{
            icon = "emergency"
            goToNewGoalVC(with: "Emergency Fund", and: icon)
        } else if sender.tag == 6{
            icon = "holiday"
            goToNewGoalVC(with: "Holiday Trip", and: icon)
        }
    }
    
    private func goToNewGoalVC(with name: String, and icon: String){
        let newGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.newGoal) as! NewGoalViewController
        newGoalVC.iconName = icon
        newGoalVC.goalName = name
        self.navigationController?.pushViewController(newGoalVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if goalNameTxt.isFirstResponder {
            goalNameTxt.resignFirstResponder()
        }
    }
}

//MARK:- textfield delegate extension
extension AddGoalViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        goalNameTxt.textFieldStyle(color: focusedTextFieldColor)
        goalNameTxt.placeholder = "enter your goal name"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        goalNameTxt.textFieldStyle(color: .darkGray)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if goalNameTxt.isFirstResponder {
//            goalNameTxt.resignFirstResponder()
//        }
//        return false
//    }
}
