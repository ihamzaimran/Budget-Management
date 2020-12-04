//
//  SetMonthlyBudgetViewController.swift
//  Budget Management
//
//  Created by Intern on 02/12/2020.
//

import UIKit
import XLPagerTabStrip
import DropDown

class SetMonthlyBudgetViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let icons = Constants.Images.expenseIcon
    private let iconText = Constants.Text.expenseIconText
    var childNumber: String = ""
    private let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "\(childNumber)")
    }
    
}

//MARK:- extension collection view

extension SetMonthlyBudgetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GetViewCellNumDelegate {
    
    
    //delegate methods to get cell number to show drop down on it.
    func didTapCollectionViewBudgetMenu(cell: SetBudgetCollectionViewCell) {
        
        guard let indexPath = self.collectionView.indexPath(for: cell) else{fatalError("error getting index path")}
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            dropDown.dataSource = ["Clear Budget", "Set Budget"]
            dropDown.anchorView = cell
            dropDown.bottomOffset = CGPoint(x: cell.frame.width-25, y: 25)
            dropDown.width = 150
            dropDown.direction = .bottom
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                guard let _ = self else { return }
                
                switch item {
                case "Clear Budget":
                    print("clear")
                case "Set Budget":
                    print("set")
                default:
                    print("not found")
                    break
                }
            }
        }
        
        dropDown.show()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.TableViewIdentifier.setBudget, for: indexPath) as! SetBudgetCollectionViewCell
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.image.image = UIImage(named: icons[indexPath.row])
        cell.titleLBL.text = iconText[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellSize = collectionView.frame.size.width
        return CGSize(width: 355/3, height: collectionCellSize/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let updateBudgetVC = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.editBudgetStoryboard) as! EditMonthlyBudgetViewController
        updateBudgetVC.index = indexPath.row
        updateBudgetVC.imageIcon = icons[indexPath.row]
        updateBudgetVC.titleText = iconText[indexPath.row]
        self.navigationController?.pushViewController(updateBudgetVC, animated: true)
    }
}
