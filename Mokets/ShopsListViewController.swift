//
//  CityListControllerViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 11/19/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire


class ShopsListControllerViewController: UICollectionViewController{
    
    var populationPhotos = false
    var currentPage = 1
    var selectedShopArrayIndex: Int!
    var allShops = [ShopModel]()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            collectionView!.isPrefetchingEnabled = false
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loadAllShops()
        
        
        _ = Common.instance.loadBackgroundImage(view)
        
        
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView!.register(ShopCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ShopCell")
        
        defaultValue = collectionView?.frame.origin
        animateCollectionView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedShop" {
            weak var cityCell = sender as? ShopCell
            weak var selectedShopController = segue.destination as? SelectedShopViewController
            weak var shopModel = cityCell!.shopmodel
            selectedShopController!.shopModel = shopModel
            selectedShopController!.selectedShopArrayIndex = selectedShopArrayIndex
            updateBackButton()
          
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allShops.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as? ShopCell
        cell!.shopmodel = allShops[(indexPath as NSIndexPath).item]
        let imageURL = configs.imageUrl + allShops[(indexPath as NSIndexPath).item].backgroundImage
        
        cell!.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionViewLayout as! PallaxLayout
        let offset = layout.dragOffset * CGFloat((indexPath as NSIndexPath).item)
        
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
        selectedShopArrayIndex = (indexPath as NSIndexPath).row
        let cell = collectionView.cellForItem(at: indexPath) as! ShopCell
        performSegue(withIdentifier: "selectedShop", sender: cell)
    }
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateLabelFrame(_ text:NSString!, font:UIFont!) -> CGFloat {
        let maxSize = CGSize(width: 320, height: CGFloat(MAXFLOAT)) as CGSize
        let expectedSize = NSString(string: text!).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:  [NSAttributedStringKey.font: font], context: nil).size as CGSize
        return expectedSize.height;
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.homePageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
    func showNotiIfExists(){
        let prefs = UserDefaults.standard
        
        let keyValue = prefs.string(forKey: notiKey.notiMessageKey)
        if keyValue != nil {
            
            let alert = UIAlertController(title: "", message:keyValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            
            prefs.removeObject(forKey: notiKey.notiMessageKey)
        }
    }
    
    func loadAllShops() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.GetShops()).responseCollection {
            (response: DataResponse<[Shop]>) in
            
            
            if response.result.isSuccess {
                if let shops: [Shop] = response.result.value {
                    
                    
                    if shops.count > 0 {
                    
                        for shop in shops {
                            
                            let oneShop = ShopModel(shop: shop)
                            self.allShops.append(oneShop)
                            
                        }
                        
                        self.collectionView?.reloadData()
                        _ = EZLoadingActivity.hide()
                        ShopsListModel.sharedManager.shops = self.allShops
                    
                    } else {
                        self.menuButton.isEnabled = false
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.warning)
                    }
 
                    print(shops.count)
 
                    
                
                }
                
                
                
                //Show noti message, if there is new noti message
                self.showNotiIfExists();
                
                
                
            } else {
                print("Response is fail.")
                _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.tryAgainToConnect, style: AlertStyle.warning)
            }
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







