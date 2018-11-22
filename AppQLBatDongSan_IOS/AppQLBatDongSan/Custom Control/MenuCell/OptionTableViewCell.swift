//
//  OptionTableViewCell.swift
//  ConnectPOS
//
//  Created by HarryNg on 10/13/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitleOption: UILabel!
    @IBOutlet weak var imgOption: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDataForOption(nameImage image:String, titleOption title:String ) -> Void {
        self.imgOption.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        self.lbTitleOption.text = title.uppercased()
    }
    
}
