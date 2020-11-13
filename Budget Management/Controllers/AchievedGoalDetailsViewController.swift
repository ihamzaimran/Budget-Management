//
//  AchievedGoalDetailsViewController.swift
//  Budget Management
//
//  Created by Intern on 13/11/2020.
//

import UIKit
import RealmSwift
import Toast_Swift
import Charts

class AchievedGoalDetailsViewController: UIViewController {

    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var targetDate: UILabel!
    @IBOutlet weak var achievedDate: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var savedLBL: UILabel!
    
    private let realm = try! Realm()
    internal var goalDetail: GoalAchieved?
    private var goals: [Int] = []
    private let labels = ["Saved"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.delegate = self
        getData()
    }
    
    private func getData(){
        if let detail = goalDetail {
            
            goalImage.image = UIImage(named: detail.goalIcon)
            goalName.text = detail.goalName
            targetDate.text = ("Target Date: \(detail.targetDate)")
            achievedDate.text = ("Achieved Date: \(detail.achievedDate)")
            goalAmount.text = "Goal: \(detail.totalGoalAmount)"
            savedLBL.text = "Saved: \(detail.totalGoalAmount) / \(detail.totalGoalAmount)"
            let savedPercent = 100
            
            goals = [savedPercent]
            customizeChart(dataPoints: labels, values: goals.map{ Double($0) })
            setUpChart()
        } else {
            self.view.makeToast("couldn't find goal.")
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteIconBtn(_ sender: UIButton) {
        if let goalDetail = goalDetail {
            do {
                try realm.write {
                    realm.delete(goalDetail)
                    self.view.makeToast("goal deleted successfully.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                self.view.makeToast("Error deleting goal.")
                print("Error deleting goal. \(error.localizedDescription)")
            }
        }

        
    }
    
    @IBAction func viewSavingsButton(_ sender: UIButton) {
        let transactionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.goalTransactions) as! GoalTransactionsViewController
        transactionsVC.achievedGoalTransactions = goalDetail
        self.navigationController?.pushViewController(transactionsVC, animated: true)
    }
    
}


//MARK:- extension chartViewDelegate

extension AchievedGoalDetailsViewController: ChartViewDelegate {

    private func setUpChart(){

        let l = pieChartView.legend
        l.enabled = false

        pieChartView.drawHoleEnabled = true
        pieChartView.centerText = "Saved"
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

        pieChartDataSet.setColors(UIColor(named: "PrimaryColor")!)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        pieChartData.setValueFont(.systemFont(ofSize: 14, weight: .bold))
        pieChartData.setValueTextColor(.darkGray)

        pieChartView.data = pieChartData
        pieChartView.highlightValues(nil)
    }
}
