//
//  ExpenseViewController.swift
//  Budget Management
//
//  Created by Intern on 27/10/2020.
//

import UIKit
import XLPagerTabStrip
import DropDown
import RealmSwift

class ExpenseViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noCategoryLBL: UILabel!
    
    private var newCategoryAlert = NewCategoryView()
    private let dropdown = DropDown()
    private var iconName = "salary"
    private var userID: String?
    private let userDefault = UserDefaults.standard
    var childNumber: String = ""
    private let realm = try! Realm()
    private var expenseCategories = List<Category>()
    private var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = userDefault.string(forKey: "UserID")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UITableViewHeaderFooterView()
        
        getDetails()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
    
    
    @IBAction func addExpenseCategoryBTN(_ sender: UIButton) {
        
        setLabel()
        newCategoryAlert.tag = 1
        view.addSubview(newCategoryAlert)
    }
    
    private func getDetails(){
        
        if let id = userID{
            if let profile = self.realm.objects(ProfileModel.self).filter("id = %@", id).first{
                
                expenseCategories = profile.expenseCategory
                tableView.reloadData()
            }
        }
    }
    
    private func setLabel(){
        newCategoryAlert = (Bundle.main.loadNibNamed("NewCategoryView", owner: self, options: nil)?.first as? NewCategoryView)!
        newCategoryAlert.categoryTitleLBL.text = "New Income Category"
        newCategoryAlert.titleTxtField.textFieldStyle(color: .darkGray)
        //        newCategoryAlert.titleTxtField.delegate = self
        newCategoryAlert.cancelBTN.addTarget(self, action: #selector(self.canceBtnPressed(_:)), for: .touchUpInside)
        newCategoryAlert.saveBTN.addTarget(self, action: #selector(self.saveBtn(_:)), for: .touchUpInside)
        newCategoryAlert.selectIconBtn.addTarget(self, action: #selector(self.selectIconBtn(_:)), for: .touchUpInside)
        newCategoryAlert.deleteBtn.addTarget(self, action: #selector(self.deleteBtnPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func canceBtnPressed(_ sender: UIButton){
        newCategoryAlert.tag = 0
        newCategoryAlert.removeFromSuperview()
    }
    
    @objc private func saveBtn(_ sender: UIButton){
        
        if newCategoryAlert.titleTxtField.text?.isEmpty ?? true {
            self.view.makeToast("category title cannot be empty", duration: 1.5, position: .bottom)
        } else {
            saveData()
        }
    }
    
    @objc private func deleteBtnPressed(_ sender: UIButton){
        
        if let category = selectedCategory{
            
            do {
                try self.realm.write {
                    realm.delete(category)
                    self.view.makeToast("category deleted!", duration: 1.5, position: .bottom)
                }
            } catch {
                self.view.makeToast("error = \(error.localizedDescription)", duration: 1.5, position: .bottom)
                print("error = \(error.localizedDescription)")
            }
            newCategoryAlert.tag = 0
            newCategoryAlert.removeFromSuperview()
            tableView.reloadData()
        }
    }
    
    private func saveData(){
        
        if let userid = userID {
            if let profile = self.realm.objects(ProfileModel.self).filter("id = %@", userid).first{
                
                if newCategoryAlert.saveBTN.tag == 1 {
                    do {
                        if let category = selectedCategory {
                            
                            try self.realm.write {
                                category.icon = iconName
                                category.title = newCategoryAlert.titleTxtField.text!
                                self.view.makeToast("category updated!", duration: 1.5, position: .bottom)
                            }
                        }
                        
                    } catch {
                        self.view.makeToast("error = \(error.localizedDescription)", duration: 1.5, position: .bottom)
                        print("error = \(error.localizedDescription)")
                    }
                } else {
                    do {
                        try self.realm.write {
                            
                            let category = Category()
                            category.title = newCategoryAlert.titleTxtField.text!
                            category.icon = iconName
                            profile.expenseCategory.append(category)
                            self.view.makeToast("category saved!", duration: 1.5, position: .bottom)
                            
                        }
                    } catch {
                        self.view.makeToast("error = \(error.localizedDescription)", duration: 1.5, position: .bottom)
                        print("error = \(error.localizedDescription)")
                    }
                    
                }
            }
        }
        
        newCategoryAlert.saveBTN.tag = 0
        newCategoryAlert.tag = 0
        newCategoryAlert.removeFromSuperview()
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if newCategoryAlert.tag == 1 {
            if newCategoryAlert.titleTxtField.isFirstResponder{
                newCategoryAlert.titleTxtField.resignFirstResponder()
            }
        }

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
        
        if expenseCategories.isEmpty {
            noCategoryLBL.isHidden = false
            tableView.isHidden = true
        } else {
            noCategoryLBL.isHidden = true
            tableView.isHidden = false
        }
        return expenseCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.expenseCellIdentifier, for: indexPath) as! ExpenseTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let category = expenseCategories[indexPath.row]
        
        cell.expenseImageView.image = UIImage(named: category.icon)
        cell.expenseLBL.text = category.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        setLabel()
        newCategoryAlert.saveBTN.tag = 1
        newCategoryAlert.categoryTitleLBL.text = "Update Expense Category"
        newCategoryAlert.titleTxtField.text = expenseCategories[indexPath.row].title
        newCategoryAlert.categoryImage.image = UIImage(named: expenseCategories[indexPath.row].icon)
        newCategoryAlert.deleteBtn.isHidden = false
        selectedCategory = expenseCategories[indexPath.row]
        newCategoryAlert.tag = 1
        view.addSubview(newCategoryAlert)
    }
}



