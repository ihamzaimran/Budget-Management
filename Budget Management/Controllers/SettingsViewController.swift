//
//  SettingsViewController.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let images = Constants.Images.settingsImages
    private let text = Constants.Text.settingsText
    private let subTitle = Constants.Text.settingssubText
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.backgroundColor = .white
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- extension tableView

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewIdentifier.settingsCellIdentifier, for: indexPath) as! SettingsTableViewCell
        cell.backgroundColor = .clear
        cell.settingsImageView.image = UIImage(named: images[indexPath.row])
        cell.titleLBL.text = text[indexPath.row]
        cell.subtitleLBL.text = subTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
