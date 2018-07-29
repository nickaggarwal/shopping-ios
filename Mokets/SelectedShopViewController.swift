//
//  SelectedCityViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 3/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

@objc protocol UpdateBasketCountsDelegate: class {
    func updateBasketCounts(_ basketCount: Int)
}

@objc protocol SelectedShopBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class SelectedShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories: [AnyObject] = []
    var selectedShopId: Int!
    var selectedShopCoverImage: String!
    var selectedShopArrayIndex: Int!
    var subCategoriesSelected: [SubCategory] = []
    var shopModel : ShopModel? = nil
    var cats = [Categories]()
    var basketButton = MIBadgeButton()
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortform: String = ""
    var loginUserId: Int = 0
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var cityName: UILabel!
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Common.instance.isUserLogin()) {
            loadLoginUserId()
        } 
        loadShopData()
        
        selectedItemCurrencySymbol = (shopModel?.currencySymbol)!
        selectedItemCurrencyShortform = (shopModel?.currencyShortForm)!
        selectedShopId = Int((shopModel?.id)!)!
        addNavigationMenuItem()
        
        defaultValue = categoryTableView?.frame.origin
        animateTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        categoryTableView = nil
        cityName = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var categoryCell = sender as? CategoryCell
        weak var itemsGridPage = segue.destination as? ItemsGridViewController
                let selectedSubCategoryID = categoryCell!.subCategoryId
                itemsGridPage!.loginUserId = Int(loginUserId)
                itemsGridPage!.selectedSubCategoryId = Int(selectedSubCategoryID)!
                itemsGridPage!.selectedShopId = Int(shopModel!.id)!
                itemsGridPage!.selectedShopLat = shopModel!.lat
                itemsGridPage!.selectedShopLng = shopModel!.lng
                itemsGridPage!.selectedShopName = shopModel!.name
                itemsGridPage!.selectedShopDesc = shopModel!.description
                itemsGridPage!.selectedShopPhone = shopModel!.phone
                itemsGridPage!.selectedShopEmail = shopModel!.email
                itemsGridPage!.selectedShopAddress = shopModel!.address
                itemsGridPage!.selectedShopCoverImage = selectedShopCoverImage
                itemsGridPage!.selectedShopStripePublishableKey = shopModel!.stripePublishableKey
        
                itemsGridPage!.selectedShopArrayIndex = selectedShopArrayIndex
                itemsGridPage!.selectedItemCurrencySymbol = selectedItemCurrencySymbol
                itemsGridPage!.selectedItemCurrencyShortform = selectedItemCurrencyShortform
                itemsGridPage!.updateBasketCountsDelegate = self
                updateBackButton()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cats[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if((indexPath as NSIndexPath).section == 0 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CategoryHeaderCell
            cell.configure(shopModel!)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
            cell.selectedCategory = cats[(indexPath as NSIndexPath).section]
            cell.contentView.alpha = 0
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0 ){
            return 1.0;
        }
        return 32.0;
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: customFont.normalFontName, size: CGFloat(customFont.tableHeaderFontSize))
            
            if(section == 0 ){
                view.textLabel!.text = ""
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).section == 0){
            return 200.0
        }
        
        return 122
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 2, animations: {
            cell.contentView.alpha = 1.0
        })
        
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }

    
    func loadShopData() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        _ = Alamofire.request(APIRouters.GetShopByID(Int(shopModel!.id)!)).responseObject {
            (response: DataResponse<Shop>) in
            
            
            if response.result.isSuccess {
                if let oneShop: Shop = response.result.value {
                    var subCategoryArray = [SubCategories]()
                    var categoryArray = [Categories]()
                    
                    self.navigationController?.navigationBar.topItem?.title = oneShop.name
                    
                    subCategoryArray.removeAll()
                    let tempCat = Categories(id: oneShop.id!, name: oneShop.name!, subCategory: subCategoryArray)
                    categoryArray.append(tempCat)
                    
                    
                    self.shopModel?.id = oneShop.id!
                    self.shopModel?.backgroundImage = oneShop.coverImageFile!
                    self.shopModel?.name = oneShop.name!
                    self.selectedShopCoverImage = oneShop.coverImageFile!
                    
                    
                    for cat in oneShop.categories {
                        
                        subCategoryArray.removeAll()
                        
                        for subCat in cat.subCategories {
                            let tempSubCat = SubCategories(id: subCat.id!,name: subCat.name!, imageURL: subCat.coverImageFile!)
                            subCategoryArray.append(tempSubCat)
                            
                        }
                        
                        let tempCat = Categories(id: cat.id!, name: cat.name!, subCategory: subCategoryArray)
                        categoryArray.append(tempCat)
                        
                        
                    }
                    self.cats = categoryArray
                    self.categoryTableView.reloadData()
                    _ = EZLoadingActivity.hide()

                    
                } else {
                    _ = EZLoadingActivity.hide()
                    print(response)
                }
            }
            
            
        }
    }
    
    func addNavigationMenuItem() {
        let btnNewsFeed = UIButton()
        btnNewsFeed.setImage(UIImage(named: "Rss-Lite-White"), for: UIControlState())
        btnNewsFeed.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        btnNewsFeed.addTarget(self, action: #selector(SelectedShopViewController.loadNewsViewController(_:)), for: .touchUpInside)
        let itemNaviNews = UIBarButtonItem()
        itemNaviNews.customView = btnNewsFeed
        
        
        print("shop id : " + String(selectedShopId))
        print("user id : " + String(loginUserId))
        
        if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            
            if(Common.instance.isUserLogin()) {
                print("shop id : " + String(selectedShopId))
                print("user id : " + String(loginUserId))
                basketButton.badgeString = String(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
                basketButton.badgeTextColor = UIColor.black
                basketButton.badgeBackgroundColor = UIColor.white
                basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 35, 0, 10)
                basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                basketButton.setImage(UIImage(named: "Basket-Lite-White"), for: UIControlState())
                
                
                basketButton.addTarget(self, action: #selector(SelectedShopViewController.loadBasketViewController(_:)), for: UIControlEvents.touchUpInside)
                
                let itemNaviBasket = UIBarButtonItem()
                itemNaviBasket.customView = basketButton
                self.navigationItem.rightBarButtonItems = [itemNaviBasket, itemNaviNews]
            
            } else {
                self.navigationItem.rightBarButtonItems = [itemNaviNews]
            }
            
        } else {
        
           self.navigationItem.rightBarButtonItems = [itemNaviNews]
        
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
            BasketManagementViewController?.loginUserId = Int(loginUserId)
            BasketManagementViewController?.selectedShopBasketCountUpdateDelegate = self
            BasketManagementViewController?.fromWhere = "selectedshop"
            
            self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
            updateBackButton()
            
            
        } else {
            _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.warning)
        }
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc func loadNewsViewController(_ sender: UIBarButtonItem) {
        weak var feedViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedList") as? NewsFeedTableViewController
        updateBackButton()
        self.navigationController?.pushViewController(feedViewController!, animated: true)
        feedViewController?.selectedShopId = Int(shopModel!.id)!
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch{
                    
                }
                
                
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
            loginUserId           = Int(dict.object(forKey: "_login_user_id") as! String)!
        } else {
            
            if let dict = myDict {
                loginUserId           = Int(dict.object(forKey: "_login_user_id") as! String)!
            } else {
                loginUserId = 0
                print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
            }
            print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func animateTableView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.categoryTableView?.frame.origin = self.defaultValue
        }, completion: nil)
    }
    
    fileprivate func moveOffScreen() {
        categoryTableView?.frame.origin = CGPoint(x: (categoryTableView?.frame.origin.x)!,
                                                  y: (categoryTableView?.frame.origin.y)!
                                                    + UIScreen.main.bounds.size.height)
    }
    
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 15, 0, 13)
        
    }
   
}

extension SelectedShopViewController: UpdateBasketCountsDelegate {
    
    func updateBasketCounts(_ basketCount: Int) {
        basketButton.badgeString = String(basketCount)
        basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 15, 0, 13)
    }
}


extension SelectedShopViewController: SelectedShopBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
    }
}
