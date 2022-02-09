//
//  CakeListTableViewCell.swift
//  CakeItApp
//
//  Created by Sarath VS on 2/2/22.
//

import UIKit

class CakeListTableViewCell: UITableViewCell {

    @IBOutlet weak var cakeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func registerTableViewCell(tableView: UITableView) {
        tableView.register(UINib(nibName:  String(describing: self), bundle: nil), forCellReuseIdentifier: "CakeListTableViewCellID")
    }
    
}
