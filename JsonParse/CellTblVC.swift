//
//  CellTblVC.swift
//  JsonParse
//
//  Created by mac on 12/9/19.
//  Copyright © 2019 Gopabandhu. All rights reserved.
//

import UIKit

class CellTblVC: UITableViewCell {

    @IBOutlet var viewContainer: UIView!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var btnDropDown: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func cellFillUp(indexParam: String) {
        lblName.text = indexParam
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
