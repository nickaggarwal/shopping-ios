//
//  ItemDetailViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 11/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire
import Social
import UIKit
import SQLite
import AVFoundation


@objc protocol ItemDetailRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

@objc protocol ItemDetailLoginUserIdDelegate: class {
    func updateLoginUserId(_ UserId: Int)
}

@objc protocol ItemDetailBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class ItemDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    weak var refreshLikeCountsDelegate : RefreshLikeCountsDelegate!
    weak var refreshReviewCountsDelegate : RefreshReviewCountsDelegate!
    weak var favRefreshLikeCountsDelegate : FavRefreshLikeCountsDelegate!
    weak var favRefreshReviewCountsDelegate : FavRefreshReviewCountsDelegate!
    weak var searchRefreshLikeCountsDelegate : SearchRefreshLikeCountsDelegate!
    weak var searchRefreshReviewCountsDelegate : SearchRefreshReviewCountsDelegate!
    weak var refreshBasketCountsDelegate: RefreshBasketCountsDelegate!
    weak var basketTotalAmountUpdateDelegate: BasketTotalAmountUpdateDelegate!
    
    @IBOutlet weak var likeCountImage: UIImageView!
    @IBOutlet weak var reviewCountImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemLikeCount: UILabel!
    @IBOutlet weak var itemReviewCount: UILabel!
    @IBOutlet weak var itemRatingCount: UILabel!
    @IBOutlet weak var attributeLabelView: UIView!
    @IBOutlet weak var ratingPopupView: UIView!
    @IBOutlet weak var socialSharePopupView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemQty: UILabel!
    @IBOutlet weak var attributeView: UIView!
    @IBOutlet weak var ratingCountView: CosmosView!
    @IBOutlet weak var ratingInputView: CosmosView!
    @IBOutlet weak var attributePopupView: UIView!
    @IBOutlet weak var attributeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedAttributes: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var btnShopProfile: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var socialSharePopupCenterX: NSLayoutConstraint!
    @IBOutlet weak var ratingPopupCenterX: NSLayoutConstraint!
    @IBOutlet weak var attributePopupCenterX: NSLayoutConstraint!
    @IBOutlet weak var shopProfileButtonTop: NSLayoutConstraint!
    
    var tableView: UITableView = UITableView()
    let cellReuseIdentifier = "cell"
    let doneButton = UIButton(type: UIButtonType.custom)
    var attributesArray:[String] = []
    var attributesDetailArray:[String] = []
    var attributesDetailModelArray = [AttributeDetailModel]()
    var attributesDetailModelFilterArray = [AttributeDetailModel]()
    var attributesModelArray = [AttributeModel]()
    var attributesDetailSelectedArray = [AttributeDetailModel]()
    var selectedItemId:Int = 0
    var selectedShopId:Int = 0
    var selectedShopLat: String!
    var selectedShopLng: String!
    var selectedShopName: String!
    var selectedShopDesc: String!
    var selectedShopPhone: String!
    var selectedShopEmail: String!
    var selectedShopAddress: String!
    var selectedShopCoverImage: String!
    var selectedItemName: String = ""
    var selectedItemDesc: String = ""
    var selectedItemPrice: String = ""
    var selectedItemPriceAfterDiscount: String = ""
    var selectedItemDiscountPercent: String = ""
    var selectedItemImagePath: String = ""
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortform: String = ""
    var selectedItemDiscountName: String = ""
    var loginUserId:Int = 0
    var itemTitle: String = ""
    var itemSubTitle: String = ""
    var selectedAttributeStr: String = ""
    var selectedAttributeIdsStr: String = ""
    var reviews = [ReviewModel]()
    var itemImages = [ImageModel]()
    var button: UIButton = UIButton()
    var isHighLighted:Bool = false
    var buttonY: CGFloat = 20
    var calculatedPrice: Float = 0.0
    var additionalPrice: Float = 0.0
    var basketButton = MIBadgeButton()
    var itemNavi = UIBarButtonItem()
    var isBasketItem:Bool = false
    var selectedShopArrayIndex: Int!
    var isShownAlreadyBasketButton: Bool = false
    var isOpenPopup: Bool = false
    var tempPrice: String = ""
    var defaultValue: CGPoint!
    var isEditMode : Bool = false
    
    @IBAction func FacebookShare(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            facebookSheet.setInitialText(language.shareMessage)
            facebookSheet.add(URL(string: language.shareURL))
            
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: language.accountLogin, message: language.fbLogin, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func TwitterShare(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(language.shareMessage)
            twitterSheet.add(URL(string: language.shareURL))
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: language.accountLogin, message: language.twLogin, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func doOpenInquiry(_ sender: Any) {
        let inquiryFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "InquiryViewController") as? InquiryEntryViewController
        inquiryFormViewController?.selectedItemId = selectedItemId
        inquiryFormViewController?.selectedShopId = selectedShopId
        self.navigationController?.pushViewController(inquiryFormViewController!, animated: true)
        updateBackButton()
    }
    
    @IBAction func doOpenSocialPopup(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: ["Hello"+language.shareMessage, NSURL(string: language.shareURL)!], applicationActivities: nil)
        
        self.present(vc, animated: true, completion: nil)
        if let popOver = vc.popoverPresentationController {
            popOver.sourceView = sender as? UIView
            popOver.permittedArrowDirections = .init(rawValue: 0)
            
        }
    }
    
    @IBAction func GoToShopProfile(_ sender: AnyObject) {
        let shopProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShopProfileViewController") as? ShopProfileViewController
        shopProfileViewController?.title = language.shopProfile
        print("Open Shop Profile : \(selectedShopId) : \(selectedShopName)")
        shopProfileViewController?.selectedShopId = selectedShopId
        shopProfileViewController?.selectedShopName = selectedShopName
        shopProfileViewController?.selectedShopDesc = selectedShopDesc
        shopProfileViewController?.selectedShopPhone = selectedShopPhone
        shopProfileViewController?.selectedShopEmail = selectedShopEmail
        shopProfileViewController?.selectedShopAddress = selectedShopAddress
        shopProfileViewController?.selectedShopLat = selectedShopLat
        shopProfileViewController?.selectedShopLng = selectedShopLng
        shopProfileViewController?.selectedShopCoverImage = selectedShopCoverImage
        
        self.navigationController?.pushViewController(shopProfileViewController!, animated: true)
        updateBackButton()
        
    }
    
    @IBAction func attributePopupClose(_ sender: AnyObject) {
        
        if(isOpenPopup == true) {
            self.attributePopupView.isHidden = true
            attributePopupCenterX.constant -= view.bounds.width
            isOpenPopup = false
        }
    }
    
    
    @IBAction func socialSharePopupClose(_ sender: AnyObject) {
        if(isOpenPopup == true) {
            self.socialSharePopupView.isHidden = true
            socialSharePopupCenterX.constant -= view.bounds.width
            isOpenPopup = false
        }
    }
    
    @IBAction func attributePopupSelect(_ sender: AnyObject) {
        
        let headerId = attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].headerId
        attributesDetailSelectedArray = attributesDetailSelectedArray.filter({$0.headerId != headerId})
        
        let selectedAttribute = AttributeDetailModel(id: attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].id,
                                             shopId: attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].shopId,
                                             headerId: attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].headerId,
                                             itemId: attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].itemId,
                                             name: attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].name,
                                             additionalPrice: attributesDetailModelFilterArray[pickerView.selectedRow(inComponent: 0)].additionlPrice)
        
        attributesDetailSelectedArray.append(selectedAttribute)
        
        additionalPrice = 0.0
        
        attributePopupView.isHidden = true
        
        selectedAttributeStr = ""
        selectedAttributeIdsStr = ""
        if(attributesDetailSelectedArray.count > 0) {
            for attDetail in attributesDetailSelectedArray {
                selectedAttributeStr += attDetail.name + ","
                selectedAttributeIdsStr += attDetail.id + ","
                additionalPrice += Float(attDetail.additionlPrice)!
            }
            selectedAttributeStr = String(selectedAttributeStr.dropLast())
            selectedAttributeIdsStr = String(selectedAttributeIdsStr.dropLast())
        }
        
        selectedAttributes.text = language.selectedAttribute + "(" + selectedAttributeStr + ")"
        
        for index in 0..<self.attributesModelArray.count {
            if self.attributesModelArray[index].id == selectedAttribute.headerId {
                self.attributesModelArray[index].name = selectedAttribute.name
            }
        }
        
        //update price
        if(additionalPrice != 0.0) {
            
            calculatedPrice = Float(selectedItemPriceAfterDiscount)! + additionalPrice
            
            if(selectedItemDiscountName == "") {
                itemPrice.text = language.price + String(calculatedPrice) + " " + selectedItemCurrencySymbol
            } else {
                itemPrice.text = language.price + String(calculatedPrice) + " " + selectedItemCurrencySymbol + "(" + selectedItemDiscountName + ")"
            }
            
            selectedItemPrice = String(calculatedPrice)
            
        }
        
        
        tableView.reloadData()
        
        isOpenPopup = false
        attributePopupCenterX.constant -= view.bounds.width
        
        
    }
    
    @IBAction func AddNewRating(_ sender: AnyObject) {
        if(isOpenPopup == false) {
            showRatingPopupView()
        }
        
    }
    @IBAction func CloseRatingPopup(_ sender: AnyObject) {
        if(isOpenPopup == true) {
            ratingPopupView.isHidden = true
            ratingPopupCenterX.constant -= view.bounds.width
            isOpenPopup = false
        }
    }
    
    override func viewDidLoad() {
        
        loadItemData(selectedItemId,ShopId:selectedShopId)
        ImageViewTapRegister()
        loadLoginUserId()
        isLikedChecking()
        isFavouritedChecking()
        addItemTouchCount()
        
        
        self.setupDoneButtonOnKeyboard()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        attributesDetailSelectedArray.removeAll()
        attributePopupView.isHidden = true
        
        ratingPopupView.isHidden = true
        ratingInputView.rating = 0
        ratingInputView.didFinishTouchingCosmos = didFinishTouchingCosmos
        ratingCountView.updateOnTouch = false
        
        socialSharePopupView.isHidden = true
        
        txtQty.delegate = self
        txtQty.keyboardType = .numberPad

        updateQtyFromBasket()
        
        if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            if(Common.instance.isUserLogin()) {
                setupBasketButton()
                isShownAlreadyBasketButton = true
            }
        }
        
        btnShopProfile.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        attributePopupCenterX.constant -= view.bounds.width
        ratingPopupCenterX.constant -= view.bounds.width
        socialSharePopupCenterX.constant -= view.bounds.width
        
        defaultValue = mainView?.frame.origin
        
        // load attributes
        if selectedAttributeStr != "" && selectedAttributeIdsStr != "" {
            selectedAttributes.text = language.selectedAttribute + "(" + selectedAttributeStr + ")"
            
            let selectedAttrIdsArray = selectedAttributeIdsStr.split(separator: ",")
            let selectedAttrArray = selectedAttributeStr.split(separator: ",")
            
            for selectedIndex in 0..<selectedAttrIdsArray.count {
                for index in 0..<self.attributesModelArray.count {
                    if self.attributesModelArray[index].id == selectedAttrIdsArray[selectedIndex] {
                        self.attributesModelArray[index].name = String(selectedAttrArray[selectedIndex])
                    }
                }
            }
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews(){
        
        // refresh attributes
        tableView.reloadData()
    
        if(self.attributesModelArray.count > 0) {

        }else {
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 0)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            attributeViewHeight.constant = 0
            shopProfileButtonTop.constant = 10
            print("Attribute Height : \(attributeViewHeight.constant)")
            scrollView.contentSize.height = scrollView.contentSize.height + attributeViewHeight.constant + 150
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        setupAttributeTableView()
        
    }
    
    fileprivate func didFinishTouchingCosmos(_ rating: Double) {
        if(loginUserId != 0) {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params: [String: AnyObject] = [
                "appuser_id": loginUserId as AnyObject,
                "shop_id"   : selectedShopId as AnyObject,
                "rating"    : ratingInputView.rating as AnyObject
            ]
            
            _ = Alamofire.request(APIRouters.AddItemRating(selectedItemId, params)).responseObject{
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        
                        if(res.status! == "success") {
                            self.ratingInputView.rating = Double(res.data!)!
                            self.itemRatingCount.text = language.rating + String(res.data!)
                            
                            self.ratingCountView.rating = Double(res.data!)!
                            
                            self.ratingInputView.rating = 0
                            self.ratingPopupView.isHidden = true
                            self.ratingPopupCenterX.constant -= self.view.bounds.width
                            self.isOpenPopup = false
                        } else {
                            if(res.data! == "already_rated") {
                                _ = SweetAlert().showAlert(language.ratingTitle, subTitle: language.alreadyRated, style: AlertStyle.warning)
                            } else {
                                _ = SweetAlert().showAlert(language.ratingTitle, subTitle: language.ratingProblem, style: AlertStyle.warning)
                            }
                        }
                        
                        
                    }
                } else {
                    print(response)
                }
            }
        } else {
            _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.warning)
            ratingInputView.rating = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        //TOFIX
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalCount = self.attributesModelArray.count - 1
        print("Current Index \(indexPath.item) & total count \(totalCount)")
        if(indexPath.item == totalCount ) {
            print("Attribute Count : \(self.attributesModelArray.count)")
            if(self.attributesModelArray.count > 0) {
                
                var heightOfTableView: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.tableView.visibleCells
                for cell in cells {
                    heightOfTableView += cell.frame.height
                }
                
                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.none
                attributeViewHeight.constant = tableView.frame.height + 50
                shopProfileButtonTop.constant = tableView.frame.height + 50
                print("Attribute Height : \(attributeViewHeight.constant)")
                scrollView.contentSize.height = scrollView.contentSize.height + attributeViewHeight.constant + 70
            }else {
                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 0)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.none
                attributeViewHeight.constant = 0
                shopProfileButtonTop.constant = 10
                print("Attribute Height : \(attributeViewHeight.constant)")
                scrollView.contentSize.height = scrollView.contentSize.height + attributeViewHeight.constant + 70
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.attributesModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = "\(language.availableDiferent) : \(attributesModelArray[(indexPath as NSIndexPath).row].name)"
        cell.textLabel?.font = UIFont(name:"Monda", size:14)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let attId: String = attributesModelArray[(indexPath as NSIndexPath).row].id
        attributesDetailModelFilterArray = attributesDetailModelArray.filter({$0.headerId == attId})
        pickerView.reloadAllComponents()
        
        if(isOpenPopup == false) {
            attributePopupView.isHidden = true
            showAttributePopupView()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.attributesDetailModelFilterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.attributesDetailModelFilterArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        
        if(self.attributesDetailModelFilterArray[row].additionlPrice == "0") {
            pickerLabel.text = self.attributesDetailModelFilterArray[row].name
        } else {
            pickerLabel.text = self.attributesDetailModelFilterArray[row].name + " (" + self.attributesDetailModelFilterArray[row].additionlPrice + selectedItemCurrencySymbol + ")"
        }
        
        pickerLabel.font = UIFont(name: customFont.normalFontName , size: CGFloat(customFont.pickerFontSize))
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func showAttributePopupView() {
        attributePopupView.isHidden = false
        attributePopupView.layer.cornerRadius = CGFloat(5)
        attributePopupView.layer.borderWidth = 1
        attributePopupView.layer.borderColor = UIColor.red.cgColor
        attributePopupView.clipsToBounds = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.attributePopupCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        isOpenPopup = true
    }
    
    func showRatingPopupView() {
        ratingPopupView.isHidden = false
        ratingPopupView.layer.cornerRadius = CGFloat(5)
        ratingPopupView.layer.borderWidth = 1
        ratingPopupView.layer.borderColor = UIColor.red.cgColor
        ratingPopupView.clipsToBounds = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.ratingPopupCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        isOpenPopup = true
       
    }
    
    func showSocialSharePopupView() {
        socialSharePopupView.isHidden = false
        socialSharePopupView.layer.cornerRadius = CGFloat(5)
        socialSharePopupView.layer.borderWidth = 1
        socialSharePopupView.layer.borderColor = UIColor.red.cgColor
        socialSharePopupView.clipsToBounds = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.socialSharePopupCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        isOpenPopup = true
        
        
    }
    
    func updateQtyFromBasket() {
        
        let id : Int64 = checkItemInBasket()
        print(" ID : \(id)")
            if( id != 0) {
                for basket in BasketTable.getByKeyIds(String(selectedShopId), selectedId: id) {
                    print(" Basket ID : \(String(describing: basket.id))")
                    if(basket.id != 0) {
                        isBasketItem = true
                        txtQty.text = String(basket.qty!)
                        txtQty.layer.cornerRadius = 5.0
                        txtQty.layer.masksToBounds = true
                        txtQty.layer.borderColor = Common.instance.colorWithHexString(configs.barColorCode).cgColor
                        txtQty.layer.borderWidth = 1.0
                    }else {
                        isBasketItem = false
                    }
                }
            }
            
        
    }

    func checkItemInBasket() -> Int64 {
        
        print("selected item id : \(String(selectedItemId))")
        print("selected item attr : \(String(selectedAttributeIdsStr))")
        let id = BasketTable.getByIdsAndAttrs(String(selectedItemId), paramAttrIds: self.selectedAttributeIdsStr)
        print("Check ID \(id)")
        return id
    }

    
    func loadItemData(_ ItemId:Int, ShopId:Int) {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        
        _ = Alamofire.request(APIRouters.ItemById(ItemId, ShopId)).responseObject {
            (response: DataResponse<Item>) in
            _ = EZLoadingActivity.hide()
            if response.result.isSuccess {
                
                if let item: Item = response.result.value {
                    self.bindItemData(item)
                    
                    if(item.reviews.count > 0){
                        for review in item.reviews {
                            let oneReview = ReviewModel(review: review)
                            self.reviews.append(oneReview)
                        }
                    }
                    
                    if(item.images.count > 0) {
                        for image in item.images {
                            let oneImage = ImageModel(image: image)
                            self.itemImages.append(oneImage)
                            
                        }
                    }
                    
                    if(item.attributes.count > 0) {
                        
                        for att in item.attributes {
                            self.attributesArray.append(language.availableDiferent + att.name!)
                            let oneAttribute = AttributeModel(att: att)
                            self.attributesModelArray.append(oneAttribute)
                            
                            
                            if(att.attributesDetail.count > 0) {
                                for attDetail in att.attributesDetail {
                                    let oneDetail = AttributeDetailModel(attDetail: attDetail)
                                    self.attributesDetailModelArray.append(oneDetail)
                                    self.attributesDetailModelFilterArray.append(oneDetail)
                                }
                            }
                            self.pickerView.reloadAllComponents()
                        }
                        
                        // TP TODO
                        if self.selectedAttributeStr != "" && self.selectedAttributeIdsStr != "" {
                            self.selectedAttributes.text = language.selectedAttribute + "(" + self.selectedAttributeStr + ")"
                            
                            let selectedAttrIdsArray = self.selectedAttributeIdsStr.split(separator: ",")
                            let selectedAttrArray = self.selectedAttributeStr.split(separator: ",")
                            var tmpAttrPrice : Int = 0
                            
                            for selectedIndex in 0..<selectedAttrIdsArray.count {
                                for headerIndex in 0..<self.attributesModelArray.count {
                                    let tmpAttrDetail = self.attributesModelArray[headerIndex].attributeDetail
                                    for index in 0..<tmpAttrDetail.count {
                                        
                                        if let tmpId = tmpAttrDetail[index].id {
                                            
                                            if String(describing : selectedAttrIdsArray[selectedIndex]) == String(describing : tmpId) {
                                                print(" IDS -> \(String(describing : selectedAttrIdsArray[selectedIndex])) , \(String(describing : tmpId))")
                                                self.attributesModelArray[headerIndex].name = String(selectedAttrArray[selectedIndex])
                                                
                                                
                                                for tmpDetailModel in self.attributesDetailModelArray {
                                                    print (" detail ids \(tmpDetailModel.id) - \(tmpId)")
                                                    if tmpDetailModel.id == tmpId {
                                                        
                                                        tmpAttrPrice = tmpAttrPrice + Int(tmpDetailModel.additionlPrice)!
                                                        
                                                        let selectedAttribute = AttributeDetailModel(id: tmpDetailModel.id ,
                                                                                                     shopId: tmpDetailModel.shopId,
                                                                                                     headerId: tmpDetailModel.headerId,
                                                                                                     itemId: tmpDetailModel.itemId,
                                                                                                     name: tmpDetailModel.name,
                                                                                                     additionalPrice: tmpDetailModel.additionlPrice)
                                                        
                                                        self.attributesDetailSelectedArray.append(selectedAttribute)
                                                        
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            if tmpAttrPrice > 0 {
                                print("Selected Item Price :\(self.selectedItemPrice)")
                                print("Selected Attr Price : \(tmpAttrPrice)")
                                let totalPrice = Int(self.selectedItemPrice)! + tmpAttrPrice
                                self.selectedItemPrice = String(totalPrice)
                                self.itemPrice.text = language.price + String(totalPrice) + " " + self.selectedItemCurrencySymbol
                            }
                        }
                    } else {
                        self.attributeLabelView.isHidden = true
                    }
                    
                }
                
            }
            
        }
        
        tableView.reloadData()
    }
    
    func bindItemData(_ itemData:Item) {
        
        itemName.text = itemData.name
        lblDescription.text = itemData.desc
        itemLikeCount.text = String(itemData.likeCount!)
        itemReviewCount.text = String(itemData.reviewCount!)
        itemPrice.text = language.price + String(itemData.price!) + " " + itemData.currencySymbol!
        itemQty.text = language.qty
        if(itemData.ratingCount != 0.0) {
            itemRatingCount.text = language.rating + String(itemData.ratingCount!)
            ratingCountView.rating = Double(itemData.ratingCount!)
        } else {
            ratingCountView.rating = 0
            itemRatingCount.text = language.na
        }
        
        selectedItemPrice = itemData.price!
        
        if(itemData.discountTypeId != "0") {
            //attributeLabelView.hidden = true
            calculatedPrice = Float(itemData.price!)! - (Float(itemData.discountPercent!)! * Float(itemData.price!)!)
            
            tempPrice = language.price + String(calculatedPrice) + " " + itemData.currencySymbol!
            itemPrice.text = tempPrice + "(" + String(itemData.discountName!) + ")"

            selectedItemPrice = String(calculatedPrice)
            selectedItemPriceAfterDiscount = String(calculatedPrice)
            selectedItemDiscountName = itemData.discountName!
        } else {
            selectedItemPriceAfterDiscount = itemData.price!
        }
        
        
        
        if itemData.images[0].path != nil {
            let coverImageName =  itemData.images[0].path! as String
            let imageURL = configs.imageUrl + coverImageName
            
            
            self.itemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
        }
        
        selectedItemName = itemData.name!
        selectedItemDesc = itemData.desc!
        if(itemData.discountPercent! != "") {
            selectedItemDiscountPercent = itemData.discountPercent!
        } else {
            selectedItemDiscountPercent = "0.0"
        }
        selectedItemImagePath = itemData.images[0].path!
        selectedItemCurrencySymbol = itemData.currencySymbol!
        selectedItemCurrencyShortform = itemData.currencyShortForm!
        
        animateMainView()
        
    }
    
    func ImageViewTapRegister() {
        
        let reviewTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.ReviewCountImageTapped(_:)))
        reviewTap.numberOfTapsRequired = 1
        reviewTap.numberOfTouchesRequired = 1
        self.reviewCountImage.addGestureRecognizer(reviewTap)
        self.reviewCountImage.isUserInteractionEnabled = true
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.LikeCountImageTapped(_:)))
        likeTap.numberOfTapsRequired = 1
        likeTap.numberOfTouchesRequired = 1
        self.likeCountImage.addGestureRecognizer(likeTap)
        self.likeCountImage.isUserInteractionEnabled = true
        
        let favouriteTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.FavouriteImageTapped(_:)))
        favouriteTap.numberOfTapsRequired = 1
        favouriteTap.numberOfTouchesRequired = 1
        self.favouriteImage.addGestureRecognizer(favouriteTap)
        self.favouriteImage.isUserInteractionEnabled = true
        
        
        
        let itemImageTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.ItemImageTapped(_:)))
        itemImageTap.numberOfTapsRequired = 1
        itemImageTap.numberOfTouchesRequired = 1
        self.itemImage.addGestureRecognizer(itemImageTap)
        self.itemImage.isUserInteractionEnabled = true
        
    }
    
    func FavTabBarTapped(_ recognizer: UITapGestureRecognizer) {
        
    }
    
    @objc func ItemImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.ended){
            let imgSliderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlider") as? ImageSliderViewController
            self.navigationController?.pushViewController(imgSliderViewController!, animated: true)
            imgSliderViewController?.itemImages = self.itemImages
            updateBackButton()
        }
    }
    
    
    @objc func ReviewCountImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.ended){
            let reviewsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsListTableViewController") as? ReviewsListTableViewController
            self.navigationController?.pushViewController(reviewsListViewController!, animated: true)
            reviewsListViewController?.reviews = self.reviews
            reviewsListViewController?.selectedItemId = selectedItemId
            reviewsListViewController?.selectedShopId = selectedShopId
            reviewsListViewController?.itemDetailRefreshReviewCountsDelegate = self
            reviewsListViewController?.itemDetailLoginUserIdDelegate = self
            updateBackButton()
        }
    }
    
    @objc func LikeCountImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(Reachability.isConnectedToNetwork()){
            if(loginUserId != 0) {
                if(recognizer.state == UIGestureRecognizerState.ended){
                    
                    _ = EZLoadingActivity.show("Loading...", disableUI: true)
                    
                    let params: [String: AnyObject] = [
                        "appuser_id": loginUserId as AnyObject,
                        "shop_id"   : selectedShopId as AnyObject,
                        "platformName": "ios" as AnyObject
                    ]
                    
                    _ = Alamofire.request(APIRouters.AddItemLike(selectedItemId, params)).responseObject{
                        (response: DataResponse<StdResponse>) in
                        
                        _ = EZLoadingActivity.hide()
                        
                        if response.result.isSuccess {
                            if let res = response.result.value {
                                
                                if(res.status == "like_success") {
                                    self.itemLikeCount.text = String(res.intData!)
                                    self.likeCountImage.image = UIImage(named: "Like-Lite-Red")
                                    self.animateUI(imgBtn: self.likeCountImage)
                                } else {
                                    self.itemLikeCount.text = String(res.intData!)
                                    self.likeCountImage.image = UIImage(named: "Like-Lite-Black")
                                    self.animateUI(imgBtn: self.likeCountImage)
                                }
                                
                                self.refreshLikeCountsDelegate?.updateLikeCounts(res.intData!)
                                
                                self.favRefreshLikeCountsDelegate?.updateLikeCounts(res.intData)
                                self.searchRefreshLikeCountsDelegate?.updateLikeCounts(res.intData)
                                
                                
                            }
                        } else {
                            print(response)
                        }
                    }
                }
            } else {
                _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.warning)
                weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
                UserLoginViewController?.title = "Login"
                UserLoginViewController?.itemDetailLoginUserIdDelegate = self
                UserLoginViewController?.fromWhere = "like"
                self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
                
                updateBackButton()
            }
            
        } else {
            _ = SweetAlert().showAlert(language.offlineTitle, subTitle: language.offlineMessage, style: AlertStyle.warning)
        }
        
    }
    
    @objc func FavouriteImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(Reachability.isConnectedToNetwork()){
            if(loginUserId != 0) {
                
                if(recognizer.state == UIGestureRecognizerState.ended){
                    
                    _ = EZLoadingActivity.show("Loading...", disableUI: true)
                    
                    let params: [String: AnyObject] = [
                        "appuser_id": loginUserId as AnyObject,
                        "shop_id"   : selectedShopId as AnyObject,
                        "platformName": "ios" as AnyObject
                    ]
                    
                    
                    _ = Alamofire.request(APIRouters.AddItemFavourite(selectedItemId, params)).responseObject{
                        (response: DataResponse<StdResponse>) in
                        
                        _ = EZLoadingActivity.hide()
                        
                        if response.result.isSuccess {
                            if let res = response.result.value {
                                if(res.status! == "favourite_success") {
                                    self.favouriteImage.image = UIImage(named: "Favourite-Lite-Red")
                                    self.animateUI(imgBtn: self.favouriteImage)
                                } else {
                                    self.favouriteImage.image = UIImage(named: "Favourite-Lite")
                                    self.animateUI(imgBtn: self.favouriteImage)
                                }
                                
                                
                            }
                        } else {
                            print(response)
                        }
                    }
                }
                
            } else {
                _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.warning)
                let UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
                UserLoginViewController?.title = "Login"
                UserLoginViewController?.itemDetailLoginUserIdDelegate = self
                UserLoginViewController?.fromWhere = "favourite"
                self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
                updateBackButton()
                
            }
            
        } else {
            _ = SweetAlert().showAlert(language.offlineTitle, subTitle: language.offlineMessage, style: AlertStyle.warning)
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setupAttributeTableView() {
        tableView.frame = CGRect(x: 5, y: 10, width: 320, height: 200)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.attributeView.addSubview(tableView)
    }
    
    func setupDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        doneToolbar.barTintColor = UIColor.gray
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ItemDetailViewController.doneButtonAction))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.txtQty.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.txtQty.resignFirstResponder()
    }
    
    func setupBasketButton() {
       
        
        if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            basketButton.badgeString = String(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
        }
        
        basketButton.badgeTextColor = UIColor.black
        basketButton.badgeBackgroundColor = UIColor.white
        basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 35, 0, 10)
        
        basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        basketButton.setImage(UIImage(named: "Basket-Lite-White"), for: UIControlState())
        
        
        basketButton.addTarget(self, action: #selector(ItemDetailViewController.loadBasketViewController(_:)), for: UIControlEvents.touchUpInside)
        
        
        itemNavi.customView = basketButton
        
        self.navigationItem.rightBarButtonItems = [itemNavi]
        
    }
    
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsetsMake(6, 15, 0, 13)
        
    }
    
    @objc func loadBasketViewController(_ sender:UIButton) {
        
        if(isEditMode){
            self.navigationController?.popViewController(animated: true)
        }else {
            if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            
                weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
                BasketManagementViewController?.title = "Basket"
                BasketManagementViewController?.selectedItemCurrencySymbol = selectedItemCurrencySymbol
                BasketManagementViewController?.selectedShopArrayIndex = selectedShopArrayIndex
                BasketManagementViewController?.selectedItemCurrencyShortForm = selectedItemCurrencyShortform
                BasketManagementViewController?.selectedShopId = selectedShopId
                BasketManagementViewController?.loginUserId = loginUserId
                BasketManagementViewController?.itemDetailBasketCountUpdateDelegate = self
                BasketManagementViewController?.fromWhere = "detail"
                self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
                //updateBackButton()
                
            } else {
                _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.warning)
            }
        }
        
    }
    
    
    @IBAction func doAddToCart(_ sender: Any) {
    
        var id : Int64 = 0
        id = checkItemInBasket()
        if id != 0 {
            isBasketItem = true
        }else{
            isBasketItem = false
        }
        
        if(Int(txtQty.text!) != nil && String(txtQty.text!) != String(0)) {
        
            if(loginUserId != 0) {
                BasketTable.createTable()
                let basketSchema = BasketSchema()
                
                if(isBasketItem == true) {
                    
                    //existing item so need to update
                    basketSchema.itemId = String(selectedItemId)
                    basketSchema.shopId = String(selectedShopId)
                    basketSchema.userId = String(loginUserId)
                    basketSchema.name   = selectedItemName
                    basketSchema.desc              = selectedItemDesc
                    basketSchema.unitPrice         = selectedItemPrice
                    basketSchema.discountPercent   = selectedItemDiscountPercent
                    basketSchema.qty               = Int64(txtQty.text!)!
                    basketSchema.imagePath         = selectedItemImagePath
                    basketSchema.currencySymbol    = selectedItemCurrencySymbol
                    basketSchema.currencyShortForm = selectedItemCurrencyShortform
                    basketSchema.selectedAttribute = selectedAttributeStr
                    basketSchema.selectedAttributeIds = selectedAttributeIdsStr
                    
                    BasketTable.updateAllByKeyId(basketSchema, selectedShopId: String(selectedShopId), selectedId: id)
                    
                    addToCartAnimation()
                    
                } else {
                    
                    //add new item inside basket
                    basketSchema.itemId = String(selectedItemId)
                    basketSchema.shopId = String(selectedShopId)
                    basketSchema.userId = String(loginUserId)
                    basketSchema.name   = selectedItemName
                    basketSchema.desc              = selectedItemDesc
                    basketSchema.unitPrice         = selectedItemPrice
                    basketSchema.discountPercent   = selectedItemDiscountPercent
                    basketSchema.qty               = Int64(txtQty.text!)!
                    basketSchema.imagePath         = selectedItemImagePath
                    basketSchema.currencySymbol    = selectedItemCurrencySymbol
                    basketSchema.currencyShortForm = selectedItemCurrencyShortform
                    basketSchema.selectedAttribute = selectedAttributeStr
                    basketSchema.selectedAttributeIds = selectedAttributeIdsStr
                    
                    basketSchema.id = BasketTable.insert(basketSchema)
                    
                    if(isShownAlreadyBasketButton == true) {
                        basketCountUpdate(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
                    } else {
                        setupBasketButton()
                    }
                    //basketButtonShake()
                    addToCartAnimation()
                    
                }
                 self.refreshBasketCountsDelegate?.updateBasketCounts(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
                
                self.basketTotalAmountUpdateDelegate?.updateTotalAmount(Float(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count), reloadAll: true)
                
            } else {
                _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.warning)
                weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
                UserLoginViewController?.title = "Login"
                UserLoginViewController?.itemDetailLoginUserIdDelegate = self
                UserLoginViewController?.fromWhere = "cart"
                self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
                
                updateBackButton()
            }
            
        } else {
            
            _ = SweetAlert().showAlert(language.addtoCart, subTitle: language.fillQtyMessage, style: AlertStyle.warning)
        
        }
        
    }
    
    func addToCartAnimation() {
        let bounds = scrollView.bounds
        let smallFrame = scrollView.frame.insetBy(dx: scrollView.frame.size.width / 4, dy: scrollView.frame.size.height / 4)
        let finalFrame = smallFrame.offsetBy(dx: 0, dy: bounds.size.height)
        
        let snapshot = scrollView.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = scrollView.frame
        view.addSubview(snapshot!)
        //scrollView.removeFromSuperview()
        
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                snapshot?.frame = smallFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                snapshot?.frame = finalFrame
            }
            }, completion: nil)
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.itemDetailPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            
            if(dict.object(forKey: "_login_user_id") as! String == "") {
                loginUserId = 0
            } else {
                loginUserId = Int(dict.object(forKey: "_login_user_id") as! String)!
            }
            
            
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func isLikedChecking() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "shop_id"   : selectedShopId as AnyObject,
            "platformName": "ios" as AnyObject
        ]
        
        _ = Alamofire.request(APIRouters.IsLikedItem(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in
            
            if response.result.isSuccess {
                if let res = response.result.value {
                    
                    if(res.data == "yes") {
                        self.likeCountImage.image = UIImage(named: "Like-Lite-Red")
                    } else {
                        self.likeCountImage.image = UIImage(named: "Like-Lite-Black")
                    }
                    
                }
            } else {
                //print(response)
            }
        }
    }
    
    func isFavouritedChecking() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "shop_id"   : selectedShopId as AnyObject
        ]
        
        _ = Alamofire.request(APIRouters.IsFavouritedItem(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in
            
            if response.result.isSuccess {
                if let res = response.result.value {
                    
                    if(res.data == "yes") {
                        self.favouriteImage.image = UIImage(named: "Favourite-Lite-Red")
                    } else {
                        self.favouriteImage.image = UIImage(named: "Favourite-Lite")
                    }
                    
                }
            } else {
                //print(response)
            }
        }
    }
    
    func addItemTouchCount() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "shop_id"   : selectedShopId as AnyObject
        ]
        
        _ = Alamofire.request(APIRouters.AddItemTouch(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in
            
            if response.result.isSuccess {
                if let res = response.result.value {
                    
                    if(res.status == "success") {
                        //print("Successfully insert for touch count")
                    } else {
                        //print("Touch count insert got problem")
                    }
                    
                }
            } else {
                print(response)
            }
        }
    }
    
    func animateMainView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.mainView?.frame.origin = self.defaultValue
        }, completion: { finished in
            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.scrollView.alpha = 1.0
            }, completion: nil)
        })
    }
    
    fileprivate func moveOffScreen() {
        mainView?.frame.origin = CGPoint(x: (mainView?.frame.origin.x)!,
                                         y: (mainView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
    func animateUI(imgBtn : UIImageView) {
        
        AudioServicesPlaySystemSound(1057)
        
        imgBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.45),
                       initialSpringVelocity: CGFloat(5.10),
                       options: .allowUserInteraction,
                       animations: {
                        imgBtn.transform = .identity
        },
                       completion: { finished in
                        
        }
        )
        
        
    }
    
}

extension ItemDetailViewController : ItemDetailRefreshReviewCountsDelegate {
    func updateReviewCounts(_ reviewCount: Int){
        self.itemReviewCount.text = "\(reviewCount)"
        refreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
        favRefreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
        searchRefreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
    }
}

extension ItemDetailViewController: ItemDetailLoginUserIdDelegate {
    func updateLoginUserId(_ UserId: Int) {
        loginUserId = UserId
    }
}

extension ItemDetailViewController: ItemDetailBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
    }
}


