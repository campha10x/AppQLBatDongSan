//
//  ListPhongTrongTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 11/8/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ListCanHoTrongTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNamePhong: UILabel!
    
    static let id = "ListCanHoTrongTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func binding(tenPhong: String){
        lblNamePhong.text = tenPhong
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
