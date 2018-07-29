//
//  VideoCell.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import Alamofire

class CategoryCell : UICollectionViewCell {
    
    @IBOutlet weak var subCatName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    var subCategoryId: String = ""
    var request: Alamofire.Request?
 
    func loadCell() {
    
    }
}
