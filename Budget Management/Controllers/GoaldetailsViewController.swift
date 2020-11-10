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
    
    private let realm = try! Realm()
    private var goalDetails: Results<GoalDetails>?
    private let userDefault = UserDefaults.standard
    private var userID: String?
    internal var index: Int?
    let parties = ["Saved", "Goal"]
    let goals = [20, 80]
    
    var selectedGoal : GoalDetails? {
        didSet{
            print("callled")
            getDetails()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.delegate = self
        userID = userDefault.string(forKey: "UserID")
    }
    
    private func getDetails(){
        
        goalImageView.image = UIImage(named: selectedGoal?.goalIcon ?? "home+icon")
        targetDateLBL.text = ("Target Date: \(selectedGoal?.targetDate)")
        goalNameLBL.text = selectedGoal?.goalName
        goalTotalAmountLBL.text = selectedGoal?.totalGoalAmount
        
        customizeChart(dataPoints: parties, values: goals.map{ Double($0) })
        setUpChart()
    }
    
    private func setUpChart(){
        let l = pieChartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.textColor = .darkGray
        pieChartView.drawHoleEnabled = !pieChartView.drawHoleEnabled
        pieChartView.usePercentValuesEnabled = true
        pieChartView.entryLabelColor = .darkGray
        pieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editIconBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteIconBtn(_ sender: UIButton) {
        
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
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Saving Details")
        
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 2
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        pieChartData.setValueFont(.systemFont(ofSize: 12, weight: .light))
        pieChartData.setValueTextColor(.darkGray) //dfdsfgs
        
        pieChartView.data = pieChartData
        pieChartView.highlightValues(nil)
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    
    
    
    
    private func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(arc4random_uniform(range) + range / 5),
                                     label: parties[i % parties.count],
                                     icon: #imageLiteral(resourceName: "icon"))
        }
        
        //        let set = PieChartDataSet(entries: entries, label: "Goal Details")
        let set = PieChartDataSet(entries: entries)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
}
