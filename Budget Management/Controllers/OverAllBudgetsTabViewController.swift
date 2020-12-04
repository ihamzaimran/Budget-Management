//
//  OverAllBudgetsTabViewController.swift
//  Budget Management
//
//  Created by Intern on 03/12/2020.
//

import UIKit
import XLPagerTabStrip
import Charts

class OverAllBudgetsTabViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var overAllGraphView: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    
    var childNumber:String = ""
    private var goals: [Int] = []
    private let labels = ["Budget"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overAllGraphView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UITableViewHeaderFooterView()
        
        // random values. get real values from realm
        goals = [100]
        customizeChart(dataPoints: labels, values: goals.map{ Double($0) })
        setUpChart()
    }
    
    
    //MARK:- indicator info
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
    
    
    @IBAction func addBudgetBtnPressed(_ sender: UIButton) {
    }
}


//MARK:- extension charts

extension OverAllBudgetsTabViewController: ChartViewDelegate {
    
    //customize charts setup
    private func setUpChart(){
        
        let l = overAllGraphView.legend
        l.enabled = false
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.xEntrySpace = 10
        l.yEntrySpace = 0
        l.yOffset = 0
        l.textColor = .darkGray
        overAllGraphView.drawHoleEnabled = true
        overAllGraphView.usePercentValuesEnabled = true
        overAllGraphView.drawEntryLabelsEnabled = false
        overAllGraphView.rotationEnabled = false
        //        pieChartView.entryLabelColor = .black
        //        pieChartView.entryLabelFont = .systemFont(ofSize: 8, weight: .light)
        overAllGraphView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)
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
        pieChartData.setValueFont(.systemFont(ofSize: 10, weight: .bold))
        pieChartData.setValueTextColor(.darkGray)
        
        overAllGraphView.data = pieChartData
        overAllGraphView.highlightValues(nil)
    }
}


//MARK:- extension tableView

extension OverAllBudgetsTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.overallBudgetCellIndentifier, for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
