//
//  CategoryHeaderCell.swift
//  Mokets
//
//  Created by Thet Paing Soe on 3/25/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class CategoryHeaderCell : UITableViewCell {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    
    func configure(_ data: ShopModel) {
        // load image and set to header image view
        
        if data.backgroundImage != "" {
            let coverImageName = data.backgroundImage as String
            let coverImageURL = configs.imageUrl + coverImageName
            
            self.headerImageView.loadImage(urlString: coverImageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
        }
        
    }
    
}
