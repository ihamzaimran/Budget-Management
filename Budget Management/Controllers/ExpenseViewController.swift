//
//  ExpenseViewController.swift
//  Budget Management
//
//  Created by Intern on 27/10/2020.
//

import UIKit
import XLPagerTabStrip
import DropDown

class ExpenseViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let images = Constants.Images.expenseIcon
    private let text = Constants.Text.expenseIconText
    private var newCategoryAlert = NewCategoryView()
    private let dropdown = DropDown()
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
    
    
    
    @IBAction func addExpenseCategoryBTN(_ sender: UIButton) {
        
        setLabel()
        view.addSubview(newCategoryAlert)
    }
    
    private func setLabel(){
        newCategoryAlert = (Bundle.main.loadNibNamed("NewCategoryView", owner: self, options: nil)?.first as? NewCategoryView)!
        newCategoryAlert.categoryTitleLBL.text = "New Income Category"
        newCategoryAlert.titleTxtField.textFieldStyle(color: .darkGray)
//        newCategoryAlert.titleTxtField.delegate = self
        newCategoryAlert.cancelBTN.addTarget(self, action: #selector(self.canceBtnPressed(_:)), for: .touchUpInside)
        newCategoryAlert.saveBTN.addTarget(self, action: #selector(self.saveBtn(_:)), for: .touchUpInside)
        newCategoryAlert.selectIconBtn.addTarget(self, action: #selector(self.selectIconBtn(_:)), for: .touchUpInside)
    }
    
    @objc private func canceBtnPressed(_ sender: UIButton){
        newCategoryAlert.removeFromSuperview()
    }
    
    @objc private func saveBtn(_ sender: UIButton){
        newCategoryAlert.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newCategoryAlert.titleTxtField.resignFirstResponder()
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
            
            self?.iconName = item
            print("image = \(item)")
            self?.newCategoryAlert.categoryImage.image = UIImage(named: item)
        }
        
        dropdown.show()
    }
}


//MARK:- extension tableView delegate

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        text.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.expenseCellIdentifier, for: indexPath) as! ExpenseTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.expenseImageView.image = UIImage(named: images[indexPath.row])
        cell.expenseLBL.text = text[indexPath.row]
        
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



