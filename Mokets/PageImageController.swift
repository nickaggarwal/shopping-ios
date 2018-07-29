//
//  PageItemController.swift
//  Mokets
//
//  Created by Panacea-soft on 19/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit

class PageImageController: UIViewController {
 
    var itemIndex: Int = 0
    var imageDesc: String = ""
    var imageName: String = ""
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: configs.imageUrl + imageName)
        let data = try? Data(contentsOf: url!)
        let coverImage = UIImage(data: data!)
        itemImageView!.image = coverImage
        imageDescription.text = imageDesc
    }
    
    
}
