//
//  BasicCell.swift
//  RxDemo
//
//  Created by bmxd-002 on 16/11/23.
//  Copyright © 2016年 Zoey. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
