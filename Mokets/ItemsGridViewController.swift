//
//  CategoriesViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

@objc protocol RefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol RefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

@objc protocol RefreshBasketCountsDelegate: class {
    func updateBasketCounts(_ basketCount: Int)
}

@objc protocol ItemsGridBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class ItemsGridViewController: UICollectionViewController {
    
    var populationItems = false
    var selectedSubCategoryId:Int = 0
    
    var selectedShopId:Int = 0
    var selectedShopLat: String!
    var selectedShopLng: String!
    var selectedShopName: String!
    var selectedShopDesc: String!
    var selectedShopPhone: String!
    var selectedShopEmail: String!
    var selectedShopAddress: String!
    var selectedShopCoverImage: String!
    var selectedShopStripePublishableKey: String!
    var loginUserId: Int = 0
    
    var selectedShopArrayIndex: Int!
    var items = [ItemModel]()
    var currentPage = 0
    fileprivate weak var selectedCell : AnnotatedPhotoCell!
    var basketButton = MIBadgeButton()
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortform: String = ""
    weak var updateBasketCountsDelegate: UpdateBasketCountsDelegate!
    
    @IBOutlet weak var cellBackgroundView: RoundedCornersView!
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(AnnotatedPhotoCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "AnnotatedPhotoCell")
        
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        loadItemsBySubCategory()
        setupBasketButton()
        
        defaultValue = collectionView?.frame.origin
        animateCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : AnnotatedPhotoCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.item = items[(indexPath as NSIndexPath).item]
        
        let imageURL = configs.imageUrl + items[(indexPath as NSIndexPath).item].itemImage
        
        cell.imageView?.loadImage(urlString: imageURL) {  (status, url, image, msg) in
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        loadItemsBySubCategory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var itemCell = sender as? AnnotatedPhotoCell
        weak var itemDetailPage = segue.destination as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
        itemDetailPage!.selectedShopId = selectedShopId
        itemDetailPage!.selectedShopName = selectedShopName
        itemDetailPage!.selectedShopDesc = selectedShopDesc
        itemDetailPage!.selectedShopPhone = selectedShopPhone
        itemDetailPage!.selectedShopEmail = selectedShopEmail
        itemDetailPage!.selectedShopAddress = selectedShopAddress
        itemDetailPage!.selectedShopLat = selectedShopLat
        itemDetailPage!.selectedShopLng = selectedShopLng
        itemDetailPage!.selectedShopCoverImage = selectedShopCoverImage
        
        itemDetailPage!.selectedShopArrayIndex = selectedShopArrayIndex
        itemDetailPage!.refreshLikeCountsDelegate = self
        itemDetailPage!.refreshReviewCountsDelegate = self
        itemDetailPage!.refreshBasketCountsDelegate = self
        selectedCell = itemCell
        updateBackButton()
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.itemsPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    

    
    func loadItemsBySubCategory() {
        
        // show loading in very first time only
        if self.currentPage == 0 {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
        
        Alamofire.request(APIRouters.ItemsBySubCategory(selectedShopId, selectedSubCategoryId, configs.pageSize, self.currentPage)).responseCollection {
            (response: DataResponse<[Item]>) in
            
            if self.currentPage == 0 {
                _ = EZLoadingActivity.hide()
            }
            
            if response.result.isSuccess {
                if let items: [Item] = response.result.value {
                    if(items.count > 0) {
                        for item in items {
                            let oneItem = ItemModel(item: item)
                            self.items.append(oneItem)
                            self.currentPage+=1
                            
                        }
                    }
                }
               
                self.collectionView!.reloadData()
                
            } else {
                print(response)
                
            }
        }
        
    }
    
    func setupBasketButton() {
        if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            
            if(Common.instance.isUserLogin()) {
            
                basketButton.badgeString = String(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
                basketButton.badgeTextColor = UIColor.black
                basketButton.badgeBackgroundColor = UIColor.white
                basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 35, 0, 10)
                basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                basketButton.setImage(UIImage(named: "Basket-Lite-White"), for: UIControlState())
                
                
                basketButton.addTarget(self, action: #selector(ItemsGridViewController.loadBasketViewController(_:)), for: UIControlEvents.touchUpInside)
                
                let itemNaviBasket = UIBarButtonItem()
                itemNaviBasket.customView = basketButton
                self.navigationItem.rightBarButtonItems = [itemNaviBasket]
                
            }
            
        }
    }
    
    @objc func loadBasketViewController(_ sender:UIButton) {
        
        if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            
            weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
            BasketManagementViewController?.title = "Basket"
            BasketManagementViewController?.selectedItemCurrencySymbol = selectedItemCurrencySymbol
            BasketManagementViewController?.selectedShopArrayIndex = selectedShopArrayIndex
            BasketManagementViewController?.selectedItemCurrencyShortForm = selectedItemCurrencyShortform
            BasketManagementViewController?.selectedShopId = selectedShopId
            BasketManagementViewController?.loginUserId = loginUserId
            BasketManagementViewController?.itemsGridBasketCountUpdateDelegate = self
            BasketManagementViewController?.fromWhere = "grid"
            
            self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
            updateBackButton()
            
        } else {
            _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.warning)
        }
        
    }
    
    func animateCollectionView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.collectionView?.frame.origin = self.defaultValue
        }, completion: nil)
    }
    
    fileprivate func moveOffScreen() {
        collectionView?.frame.origin = CGPoint(x: (collectionView?.frame.origin.x)!,
                                               y: (collectionView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}

extension ItemsGridViewController : PinterestLayoutDelegate {
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
    
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 15, 0, 13)
        
    }
}



extension ItemsGridViewController : RefreshLikeCountsDelegate, RefreshReviewCountsDelegate, RefreshBasketCountsDelegate {
    func updateLikeCounts(_ likeCount: Int) {
        if selectedCell != nil {
            selectedCell.lblLikeCount.text = "\(likeCount)"
        }
    }
    
    func updateReviewCounts(_ reviewCount: Int) {
        if selectedCell != nil {
            selectedCell.lblReviewCount.text = "\(reviewCount)"
        }
    }
    
    func updateBasketCounts(_ basketCount: Int) {
        basketButton.badgeString = String(basketCount)
        basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 15, 0, 13)
        
        self.updateBasketCountsDelegate?.updateBasketCounts(basketCount)
    }
}

extension ItemsGridViewController: ItemsGridBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
    }
}


