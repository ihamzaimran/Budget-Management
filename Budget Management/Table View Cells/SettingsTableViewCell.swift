//
//  SettingsTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 22/10/2020.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subtitleLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
