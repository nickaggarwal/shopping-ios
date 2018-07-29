//
//  CategoriesViewController.swift
//  CitiesDirectory
//
//  Created by Thet Paing Soe on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

@objc protocol SendMsgBackDelegate: class {
    func returnmsg(msg:String)
    
    optional func returnCode(code:integer_t)
}

class CategoriesViewController: UICollectionViewController {
    
    var lbl: String?
    var appDelegate:SendMsgBackDelegate?
    var populationItems = false
    var selectedSubCategoryID:Int = 0
    var photos = [Photo]()
    var items = [ItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor =  UIColor.whiteColor()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        /*if let patternImage = UIImage(named: "Pattern") {
        view.backgroundColor = UIColor(patternImage: patternImage)
        }*/
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        //collectionView!.backgroundColor = UIColor.clearColor()
        //collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        /*
        let alert = UIAlertController(title: "Alert", message: "Message - " + self.lbl!, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
*/
        loadItemsBySubCategory()
        
    }
    
    func loadItemsBySubCategory() {
        
        //ItemsBySubCategory
        EZLoadingActivity.show("Loading...", disableUI: true)
        Alamofire.request(APIRouters.ItemsBySubCategory(1, selectedSubCategoryID, configs.itemsCount, 1)).responseCollection() {
            (response: Response<[Item],NSError>) in
            EZLoadingActivity.hide()
            if response.result.isSuccess {
                
                if let items: [Item] = response.result.value {
                    for item in items {
                        print(item.name)
                        
                        let oneItem = ItemModel(item: item)
                        
                        self.items.append(oneItem)
                        
                        self.collectionView!.reloadData()
                        /*
                        for image in item.images {
                            print(image.path)
                            
                            // show in image view
                            Alamofire.request(.GET, APIRouters.imageURLString + image.path! ).responseImage() {
                            response in
                            
                            if response.result.isSuccess {
                            
                            //imageView.image = response.result.value
                            
                            } else {
                            
                            }
                            }
                            
                            // download to directory
                            let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
                            Alamofire.download(.GET, APIRouters.imageURLString + image.path!, destination: destination)
                            
                        }
                        
                        for review in item.reviews {
                            print(review.appuserName)
                        }
                        */
                    }
                }
                
            } else {
                print(response)
            }
        }
        
    }
    
    @IBAction func onClicked(sender: UIBarButtonItem) {
        
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
        
        appDelegate?.returnmsg("This is return message from categories page")
        return
        
        
        //        dismissViewControllerAnimated(true, completion:{ () -> Void in
        //            self.delegate?.returnmsg("This is return message from categories page")
        //            return
        //        })
        
    }
    
    
    //var photos = Photo.allPhotos()
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            
            populateItems()
        }
    }
    
    func populateItems() {
        
        print(">>>> Inside populateItems <<<<")
        //2
        if self.populationItems {
            return
        }
        
        self.populationItems = true
        
        //let photos = Photo.allPhotos()
        
        
        
        /*
        for object in photos {
            self.photos.append(object)
        }
*/
        for object in items {
            self.items.append(object)
        }
        
        self.collectionView!.reloadData()
        
        print("Load More")
        
        self.populationItems = false
        
        
        
    }
    
    
}

extension CategoriesViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return photos.count
        return items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : AnnotatedPhotoCell
        
//        if(indexPath.row == 0){
//            cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell2", forIndexPath: indexPath) as! AnnotatedPhotoCell
//        }else{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        //}
        
        
        cell.item = items[indexPath.item]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row)");
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AnnotatedPhotoCell
        
        print(cell.item?.itemName);
        
        populateItems()
        
    }
    
    
    
}

extension CategoriesViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        
        //let photo = photos[indexPath.item]
        let item = items[indexPath.item]
        
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(item.itemImage.size, boundingRect)
        return rect.size.height
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        
        //let photo = photos[indexPath.item]
        let _ = items[indexPath.item]
        
        let _ = UIFont(name: "AvenirNext-Regular", size: 10)!
        
        //let commentHeight = photo.heightForComment(font, width: width)
        /*
        let commentHeight = item.heightForComment(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
*/
        let height = annotationPadding + annotationHeaderHeight + annotationPadding + 30
        
        return height
    }
}