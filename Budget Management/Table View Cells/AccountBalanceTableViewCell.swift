//
//  AccountBalanceTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 17/11/2020.
//

import UIKit

protocol GetDropDownCellNumDelegate {
    func didTapDropdownIcon(cell: AccountBalanceTableViewCell)
}


class AccountBalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var balanceLBL: UILabel!
    @IBOutlet weak var dropdownIcon: UIButton!
    
    var delegate: GetDropDownCellNumDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func dropDownBtn(_ sender: UIButton) {
        delegate?.didTapDropdownIcon(cell: self)
    }
}
