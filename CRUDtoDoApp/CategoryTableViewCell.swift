//
//  CategoryTableViewCell.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/6/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

protocol DeleteCategory {
    func deleteCategory(index: IndexPath)
}

class CategoryTableViewCell: UITableViewCell {
    
    var delegate: DeleteCategory?
    var index: IndexPath?

    @IBOutlet weak var soPhieu: UILabel!
    @IBOutlet weak var tenNguoiMuon: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func deleteCategory(_ sender: UIButton) {
        delegate?.deleteCategory(index: index!)
    }
}
