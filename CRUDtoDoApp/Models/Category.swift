//
//  Category.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/20/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit

class Category {
    var soPhieu: String
    var nguoiMuon: String
    var maSach: String
    var ngayMuon: String
    
    init(soPhieu: String, nguoiMuon: String, maSach: String, ngayMuon: String) {
        self.soPhieu = soPhieu
        self.nguoiMuon = nguoiMuon
        self.maSach = maSach
        self.ngayMuon = ngayMuon
    }
    
    
}
