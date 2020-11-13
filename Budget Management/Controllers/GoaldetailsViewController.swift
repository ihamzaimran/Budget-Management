//
//  GoaldetailsViewController.swift
//  Budget Management
//
//  Created by Intern on 10/11/2020.
//

import UIKit
import RealmSwift
import Charts

class GoaldetailsViewController: UIViewController {
    
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var goalNameLBL: UILabel!
    @IBOutlet weak var targetDateLBL: UILabel!
    @IBOutlet weak var goalTotalAmountLBL: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var goalAmountPerMonth: UILabel!
    @IBOutlet weak var lastAddedAmount: UILabel!
    @IBOutlet weak var savedAmountTxt: UILabel!
    @IBOutlet weak var perMonthTXT: UILabel!
    @IBOutlet weak var addSavingAmountStackView: UIView!
    @IBOutlet weak var minimumAmounTxt: UILabel!
    @IBOutlet weak var lastAddedTxt: UILabel!
    
    private let realm = try! Realm()
    private var goalDetails: Results<GoalDetails>?
    internal var selectedGoal: GoalDetails?
    private var goals: [Int] = []
    private let labels = ["Saved", "Left"]
    private let userDefault = UserDefaults.standard
    private var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pieChartView.delegate = self
        userID = userDefault.string(forKey: "UserID")
        getDetails()
    }
    
    private func getDetails(){
        
        if let details = selectedGoal {
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalTotalAmountLBL.text = "Goal: \(details.totalGoalAmount)"
            lastAddedAmount.text = "Amount: \(details.lastAddedSavingAmount)"
            let diff = getDifferencOfDate(for: details.targetDate)
            print("difference = \(diff)")
            
            let total = details.totalGoalAmount
            if details.savedAmount >= details.totalGoalAmount {
                perMonthTXT.isHidden = true
                lastAddedTxt.isHidden = true
                perMonthTXT.isHidden = true
                lastAddedAmount.isHidden = true
                minimumAmounTxt.isHidden = true
                addSavingAmountStackView.isHidden = true
                
                goalAmountPerMonth.textColor = UIColor(named: "PrimaryColor")
                goalAmountPerMonth.font = .systemFont(ofSize: 22, weight: .bold)
                goalAmountPerMonth.text = "Target Achieved!"
                
                do {
                    try self.realm.write {
                        details.isGoalAchieved = true
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                animateLabel()
            } else {
                if diff == 0 {
                    goalAmountPerMonth.text = "PKR: \(total-details.savedAmount)"
                } else {
                    let amountPerMonth = (total-details.savedAmount)/diff
                    goalAmountPerMonth.text = "PKR: \(amountPerMonth)"
                }
            }
            
            savedAmountTxt.text = "Saved: \(details.savedAmount) / \(total)"
            let saved = details.savedAmount
            let savedPercent = (saved * 100) / total
            let left = 100 - savedPercent
            print("saved = \((saved * 100) / total) left = \(100 - savedPercent)")
            goals = [savedPercent, left]
            customizeChart(dataPoints: labels, values: goals.map{ Double($0) })
            setUpChart()
        }
    }
    
    private func getCurrentDate()->String{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    private func animateLabel() {
        
        UIView.animate(withDuration: 1.0, delay: 0.33, options: .transitionCurlUp) {
            self.goalAmountPerMonth.alpha = 0.0
        } completion: { (_) in
            self.goalAmountPerMonth.alpha = 1.0
            
            UIView.animate(withDuration: 1.0, delay: 0.33, options: .transitionCurlDown) {
                self.goalAmountPerMonth.alpha = 0.0
            } completion: { (_) in
                self.goalAmountPerMonth.alpha = 1.0
            }
        }
    }
    
    private func getDifferencOfDate(for date: String) -> Int{
        
        let curDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let currentDate = dateFormatter.string(from: curDate)
        let cDate = dateFormatter.date(from: currentDate)
        let targetDate = dateFormatter.date(from: date)
        
        if let targetDate = targetDate, let currentDate = cDate {
            
            let diff = Calendar.current.dateComponents([.month, .year], from: currentDate, to: targetDate)
            let month = diff.month
            let year = diff.year
            
            if let mon = month, let year = year {
                return mon + year
            }
        }
        
        return 0
    }
    
    private func checkGoalAchieved(){
        
        if let details = selectedGoal {
            if details.isGoalAchieved {
                
                if let userid = userID {
                    if let goalDetails = self.realm.objects(ProfileModel.self).filter("id = %@", userid).first{
                        do {
                            try self.realm.write {
                                
                                let achievedGoal = GoalAchieved()
                                achievedGoal.goalName = details.goalName
                                achievedGoal.goalDescription = details.goalDescription
                                achievedGoal.targetDate = details.targetDate
                                achievedGoal.totalGoalAmount = details.totalGoalAmount
                                achievedGoal.accountType = details.accountType
                                achievedGoal.goalIcon = details.goalIcon
                                achievedGoal.lastAddedSavingAmount = details.lastAddedSavingAmount
                                achievedGoal.achievedDate = getCurrentDate()
                                achievedGoal.transactions = details.goalTransactions
                                goalDetails.goalAchievedDetails.append(achievedGoal)
                                self.view.makeToast("Goal set as achieved!")
                                print("Goal set as achieved!")
                                
                                realm.delete(details)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } catch {
                            self.view.makeToast("couldn't set goal as achieved!")
                            print("Error saving new items, \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                self.view.makeToast("You haven't reached your goal yet!")
                print("You haven't reached your goal yet!")
            }
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editIconBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteIconBtn(_ sender: UIButton) {
        
        if let goalDetail = selectedGoal {
            do {
                try realm.write {
                    realm.delete(goalDetail)
                    self.view.makeToast("goal deleted successfully.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                self.view.makeToast("error occured!")
                print("Error deleting goal. \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func addSavingAmountBtn(_ sender: UIButton) {
        let newDepositVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addSavingAmount) as! AddSavingAmountViewController
        newDepositVC.selectedGoalDetails = selectedGoal
        self.navigationController?.pushViewController(newDepositVC, animated: true)
    }
    
    @IBAction func goalAchievedBtn(_ sender: UIButton) {
        
        let TitleString = NSAttributedString(string: "Important", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor")!])
        
        let MessageString = NSAttributedString(string: "Are you sure you want to set goal as achieved?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor")!])
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.setValue(TitleString, forKey: "attributedTitle")
        alert.setValue(MessageString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.checkGoalAchieved()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        alert.view.tintColor = UIColor(named: "PrimaryColor")
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func viewSavingsBtn(_ sender: UIButton) {
        let transactionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.goalTransactions) as! GoalTransactionsViewController
        transactionsVC.selectedGoalTransactions = selectedGoal
        self.navigationController?.pushViewController(transactionsVC, animated: true)
    }
}


//MARK:- extension chartViewDelegate

extension GoaldetailsViewController: ChartViewDelegate {
    
    private func setUpChart(){
        
        let l = pieChartView.legend
        l.enabled = true
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.xEntrySpace = 10
        l.yEntrySpace = 0
        l.yOffset = 0
        l.textColor = .darkGray
        pieChartView.drawHoleEnabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.rotationEnabled = false
        //        pieChartView.entryLabelColor = .black
        //        pieChartView.entryLabelFont = .systemFont(ofSize: 8, weight: .light)
        pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)
    }
    
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let entry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(entry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 2
        
        pieChartDataSet.setColors(UIColor(named: "HeaderColor")!, UIColor(named: "PrimaryColor")!)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        pieChartData.setValueFont(.systemFont(ofSize: 10, weight: .bold))
        pieChartData.setValueTextColor(.darkGray)
        
        pieChartView.data = pieChartData
        pieChartView.highlightValues(nil)
    }
}
