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
    
    private let realm = try! Realm()
    private var goalDetails: Results<GoalDetails>?
    internal var selectedGoal: GoalDetails?
    private var goals: [Int] = []
    private let labels = ["Saved", "Left"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pieChartView.delegate = self
        getDetails()
    }
    
    private func getDetails(){
        
        if let details = selectedGoal {
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalTotalAmountLBL.text = "Goal: \(details.totalGoalAmount)"
            
            if let total = Int(details.totalGoalAmount) {
                savedAmountTxt.text = "Saved: \(details.savedAmount)/\(total)"
                let saved = details.savedAmount
                let savedPercent = (saved * 100) / total
                let left = 100 - savedPercent
                print("saved = \((saved * 100) / total) left = \(100 - savedPercent)")
                goals = [savedPercent, left]
                customizeChart(dataPoints: labels, values: goals.map{ Double($0) })
                setUpChart()
            }

        }
    }
    
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
        //        pieChartView.entryLabelColor = .black
        //        pieChartView.entryLabelFont = .systemFont(ofSize: 8, weight: .light)
        pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editIconBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteIconBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func addSavingAmountBtn(_ sender: UIButton) {
        let newDepositVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.addSavingAmount) as! AddSavingAmountViewController
        newDepositVC.selectedGoalDetails = selectedGoal
        self.navigationController?.pushViewController(newDepositVC, animated: true)
    }
    
    @IBAction func goalAchievedBtn(_ sender: UIButton) {
    }
    
    @IBAction func viewSavingsBtn(_ sender: UIButton) {
    }
}


//MARK:- extension chartViewDelegate

extension GoaldetailsViewController: ChartViewDelegate {
    
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let entry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(entry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 5
        
        pieChartDataSet.setColors(UIColor(named: "HeaderColor")!, UIColor(named: "PrimaryColor")!)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        pieChartData.setValueFont(.systemFont(ofSize: 10, weight: .semibold))
        pieChartData.setValueTextColor(.darkGray)
        
        pieChartView.data = pieChartData
        pieChartView.highlightValues(nil)
    }
}
