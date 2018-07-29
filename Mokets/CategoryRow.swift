//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import Alamofire

class CategoryRow : UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var selectedCategory:Categories? = nil {
        didSet {
            self.collectionView.reloadData()
        }
    }
}
    
extension CategoryRow : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCategory!.subCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        cell.subCatName.text = selectedCategory!.subCategory[(indexPath as NSIndexPath).row].name
        
        let backgroundName =  selectedCategory!.subCategory[(indexPath as NSIndexPath).row].imageURL as String
        let imageURL = configs.imageUrl + backgroundName
        
        cell.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        cell.bgView.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        cell.subCategoryId = selectedCategory!.subCategory[(indexPath as NSIndexPath).item].id
        
        return cell

        
    }
}


