//
//  SetBudgetCollectionViewCell.swift
//  Budget Management
//
//  Created by Intern on 02/12/2020.
//

import UIKit

protocol GetViewCellNumDelegate {
    func didTapCollectionViewBudgetMenu(cell: SetBudgetCollectionViewCell)
}

class SetBudgetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    
    var delegate: GetViewCellNumDelegate?
    
 
    @IBAction func menDropDownBtn(_ sender: UIButton) {
        delegate?.didTapCollectionViewBudgetMenu(cell: self)
    }
    
}
