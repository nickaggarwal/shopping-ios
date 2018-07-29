//
//  SearchResult.swift
//  Mokets
//
//  Created by Panacea-soft on 26/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

@objc protocol SearchRefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol SearchRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

class SearchResultViewController : UICollectionViewController {
    
    var populationItems = false
    var selectedSubCategoryId:Int = 0
    var selectedCityId:Int = 1
    var items = [ItemModel]()
    var currentPage = 0
    var searchKeyword: String!
    weak var selectedCellSearch : AnnotatedPhotoCell!
    
    
    override func viewDidLoad() {
        collectionView!.register(AnnotatedPhotoCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "AnnotatedPhotoCell")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        searchItemsByKeyword()
        
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchItemsByKeyword()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var itemCell = sender as? AnnotatedPhotoCell
        weak var itemDetailPage = segue.destination as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
        itemDetailPage!.selectedShopId = Int((itemCell!.item?.itemShopId)!)!
        itemDetailPage!.searchRefreshLikeCountsDelegate = self
        itemDetailPage!.searchRefreshReviewCountsDelegate = self
        selectedCellSearch = itemCell
        updateBackButton()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : AnnotatedPhotoCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.item = items[(indexPath as NSIndexPath).item]
        
        let imageURL = configs.imageUrl + items[(indexPath as NSIndexPath).item].itemImage
        
        cell.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                self.items[indexPath.item].itemImageBlob = image
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        cell.imageView.alpha    = 0
        cell.captionLabel.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            cell.imageView.alpha    = 1.0
            cell.captionLabel.alpha = 1.0
        }, completion: nil)
        
        return cell
        
    }
    
    func searchItemsByKeyword() {
        
        let params: [String: AnyObject] = [
            "keyword"   : searchKeyword as AnyObject
        ]
        
        if self.currentPage == 0 {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
        
        Alamofire.request(APIRouters.SearchByKeyword(selectedCityId, params)).responseCollection {
            (response: DataResponse<[Item]>) in
            
            if self.currentPage == 0 {
                _ = EZLoadingActivity.hide()
            }
            if response.result.isSuccess {
                if let items: [Item] = response.result.value {
                    
                    if(items.count > 1) {
                        self.title = String(items.count) + " Results Found"
                    } else if (items.count == 1) {
                        self.title = String(items.count) + " Result Found"
                    }else {
                        self.title = "0 Result Found"
                    }
                    self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor: UIColor.white]
                    
                    if(items.count > 0) {
                        self.items.removeAll()
                        for item in items {
                            let oneItem = ItemModel(item: item)
                            self.items.append(oneItem)
                            self.currentPage += 1
                            
                        }
                    }
                }else {
                    self.title = " 0 Result Found"
                }
                
                self.collectionView!.reloadData()
                
            } else {
                self.title = " 0 Result Found"
                print(response)
                
            }
        }
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}


extension SearchResultViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        
        let item = items[(indexPath as NSIndexPath).item]
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        
        let size = CGSize(width: item.itemImageWidth, height: item.itemImageHeight)
        var rect : CGRect
        if item.itemImageBlob != nil {
            rect  = AVMakeRect(aspectRatio: item.itemImageBlob!.size, insideRect: boundingRect)
        }else{
            rect  = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
            
        }
        
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let height = annotationPadding + annotationHeaderHeight + annotationPadding + 30
        return height
    }
}

extension SearchResultViewController : SearchRefreshLikeCountsDelegate, SearchRefreshReviewCountsDelegate {
    func updateLikeCounts(_ likeCount: Int) {
        print("updateLikeCounts")
        if selectedCellSearch != nil {
            print("update like count inside")
            selectedCellSearch.lblLikeCount.text = "\(likeCount)"
        }
    }
    
    func updateReviewCounts(_ reviewCount: Int) {
        if selectedCellSearch != nil {
            selectedCellSearch.lblReviewCount.text = "\(reviewCount)"
        }
    }
}








