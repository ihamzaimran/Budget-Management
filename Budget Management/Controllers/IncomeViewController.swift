//
//  IncomeViewController.swift
//  Budget Management
//
//  Created by Intern on 27/10/2020.
//

import UIKit
import XLPagerTabStrip
import DropDown

class IncomeViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dropdown = DropDown()
    private let icons = Constants.Images.expenseIcon
    private let text = Constants.Text.expenseIconText
    private var newCategoryAlert = NewCategoryView()
    private var iconName = "salary"
    
    var childNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
    @IBAction func incomeAddBtn(_ sender: UIButton) {
        print("Button Tapped!")
        
        setLabel()
        
        setLabel()
        view.addSubview(newCategoryAlert)
    }
    
    private func setLabel(){
        newCategoryAlert = (Bundle.main.loadNibNamed("NewCategoryView", owner: self, options: nil)?.first as? NewCategoryView)!
        newCategoryAlert.categoryTitleLBL.text = "New Income Category"
        newCategoryAlert.titleTxtField.textFieldStyle(color: .darkGray)
//        newCategoryAlert.titleTxtField.delegate = self
        newCategoryAlert.cancelBTN.addTarget(self, action: #selector(self.cancelBtn(_:)), for: .touchUpInside)
        newCategoryAlert.saveBTN.addTarget(self, action: #selector(self.saveBtn(_:)), for: .touchUpInside)
        newCategoryAlert.selectIconBtn.addTarget(self, action: #selector(self.selectIconBtn(_:)), for: .touchUpInside)
    }
    
    @objc private func selectIconBtn(_ sender: UIButton){
        print("select icon")
        
        dropdown.dataSource = Constants.Images.iconArray
        dropdown.anchorView = newCategoryAlert.selectIconView
        dropdown.bottomOffset = CGPoint(x: 0, y: newCategoryAlert.selectIconView.frame.height)
        dropdown.direction = .bottom
        
        dropdown.cellNib = UINib(nibName: "SelectIconCell", bundle: nil)
        dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SelectIconCell else { return }
            
            // Setup your custom UI components
            cell.iconImage.image = UIImage(named: item)
        }
        
        dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            
            print("image = \(item)")
            self?.iconName = item
            self?.newCategoryAlert.categoryImage.image = UIImage(named: item)
        }
        
        dropdown.show()
    }
    
    @objc private func cancelBtn(_ sender: UIButton){
       newCategoryAlert.removeFromSuperview()
   }
    
    @objc private func saveBtn(_ sender: UIButton){
        newCategoryAlert.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newCategoryAlert.titleTxtField.resignFirstResponder()
    }
}


 

//MARK:- extension tableviewDelegate

extension IncomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        text.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.incomeCellIdentifier, for: indexPath) as! IncomeTableViewCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.incomeImageView.image = UIImage(named: icons[indexPath.row])
        cell.incomeLBL.text = text[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        setLabel()
        view.addSubview(newCategoryAlert)
    }
}

