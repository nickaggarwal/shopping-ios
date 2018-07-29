//
//  BasketViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 3/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import SQLite
import Alamofire
import UIKit


@objc protocol BasketTotalAmountUpdateDelegate: class {
    func updateTotalAmount(_ amount: Float, reloadAll : Bool)
}

class BasketViewController: UITableViewController {
    
    @IBOutlet var basketTableView: UITableView!
    var basketItems = [BasketSchema]()
    var calculatedTotalPrice: Float = 0.0
    var calculatedPrice:Float = 0.0
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortForm: String = ""
    var selectedShopArrayIndex: Int!
    var selectedShopId: Int!
    var loginUserId:Int = 0
    var amountLabel = UILabel()
    var defaultValue: CGPoint!
    var fromWhere: String = ""
    weak var itemDetailBasketCountUpdateDelegate: ItemDetailBasketCountUpdateDelegate!
    weak var itemsGridBasketCountUpdateDelegate: ItemsGridBasketCountUpdateDelegate!
    weak var selectedShopBasketCountUpdateDelegate: SelectedShopBasketCountUpdateDelegate!
    
    override func viewDidLoad() {
        loadBasket()
        setupPaymentOptionButton()
        setupCustomBackButton()
        
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
        defaultValue = tableView?.frame.origin
        animateTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketCell
        let bskItem = basketItems[(indexPath as NSIndexPath).row]
        
        cell.configure(bskItem.id!,shopId: bskItem.shopId!,itemId: bskItem.itemId!,itemTitle:bskItem.name!,itemPrice: bskItem.unitPrice!, itemQty: bskItem.qty!, itemCurrencySymbol : bskItem.currencySymbol!, itemDiscountPerdent : bskItem.discountPercent!,  itemCoverImage: bskItem.imagePath!, userId: loginUserId, selectedAttribute : bskItem.selectedAttribute!, selectedAttributeIds : bskItem.selectedAttributeIds!)
        
        cell.basketTotalAmountUpdateDelegate = self
        
        let imageURL = configs.imageUrl + bskItem.imagePath!
        
        cell.coverImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        cell.coverImage.alpha = 0
        cell.title.alpha = 0
        cell.price.alpha = 0
        cell.qty.alpha = 0
        cell.subTotalAmount.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            cell.coverImage.alpha = 1.0
            cell.title.alpha = 1.0
            cell.price.alpha = 1.0
            cell.qty.alpha = 1.0
            cell.subTotalAmount.alpha = 1.0
        }, completion: nil)
        
        return cell
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Remove") { (action , indexPath ) -> Void in
            self.isEditing = false
            let bskItem = self.basketItems[(indexPath as NSIndexPath).row]
            
            BasketTable.deleteByKeyIds(bskItem.shopId!, selectedId: Int64(bskItem.id!))
            self.basketItems.removeAll()
            self.calculatedPrice = 0.0
            self.loadBasket()
            self.basketTableView.reloadData()
            self.amountLabel.text = language.total + String(self.calculatedPrice) + self.selectedItemCurrencySymbol
            
            print("Delete ID : \(String(describing: bskItem.id))")
            
        }
        
        return [removeAction]
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row : \(indexPath.row)")
        
        weak var itemCell = tableView.cellForRow(at: indexPath) as? BasketCell
        weak var itemDetailPage = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController
        self.navigationController?.pushViewController(itemDetailPage!, animated: true)
        
        itemDetailPage!.selectedItemId = Int((itemCell!.selectedItemId))!
        itemDetailPage!.selectedShopId = selectedShopId
        itemDetailPage!.selectedAttributeStr = itemCell!.selectedAttribute
        itemDetailPage!.selectedAttributeIdsStr = itemCell!.selectedAttributeIds
        itemDetailPage!.selectedShopArrayIndex = selectedShopArrayIndex
        itemDetailPage!.refreshLikeCountsDelegate = nil
        itemDetailPage!.refreshReviewCountsDelegate = nil
        itemDetailPage!.basketTotalAmountUpdateDelegate = self
        itemDetailPage!.isEditMode = true
        
        updateBackButton()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        //footerView.backgroundColor = UIColor.blackColor()
        footerView.backgroundColor = Common.instance.colorWithHexString("#bcbbbb")
        
        
        //label.center = CGPointMake(160, 284)
        amountLabel = UILabel(frame: CGRect(x: 8, y: 5, width: tableView.frame.width, height: 30))
        amountLabel.textAlignment = NSTextAlignment.center
        amountLabel.textColor = UIColor.red
        amountLabel.font = UIFont(name: "Monda", size: 14)
        amountLabel.text = language.total + String(calculatedPrice) + selectedItemCurrencySymbol
        
        footerView.addSubview(amountLabel)
        
        return footerView
        

    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }

    
    func loadBasket() {
     
        for basket in BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)) {
            calculatedPrice += Float(basket.unitPrice!)! * Float(basket.qty!)
            basketItems.append(basket)
            
        }
        
    }
    
    func setupPaymentOptionButton() {
        let btnPaymentOption = UIButton()
        btnPaymentOption.setImage(UIImage(named: "Selection-Lite"), for: UIControlState())
        btnPaymentOption.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        btnPaymentOption.addTarget(self, action: #selector(BasketViewController.loadPaymentOptionsViewController(_:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnPaymentOption
        self.navigationItem.rightBarButtonItems = [itemNavi]
    }
    
    func setupCustomBackButton() {
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "Back"), for: UIControlState())
        btnBack.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        btnBack.addTarget(self, action: #selector(BasketViewController.back(sender:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnBack
        self.navigationItem.leftBarButtonItems = [itemNavi]
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        if(basketItems.count == 0) {
            _ = self.navigationController?.popToRootViewController(animated: true)
        } else {
            _ = navigationController?.popViewController(animated: true)
            if(fromWhere == "detail") {
                self.itemDetailBasketCountUpdateDelegate.updateBasketCount()
            } else if(fromWhere == "grid") {
                self.itemsGridBasketCountUpdateDelegate.updateBasketCount()
            } else if(fromWhere == "selectedshop") {
                self.selectedShopBasketCountUpdateDelegate.updateBasketCount()
            }
        }
    }
    
    @objc func loadPaymentOptionsViewController(_ sender: UIBarButtonItem) {

        calculatedPrice = 0.0
        for basket in BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)) {
            calculatedPrice += Float(basket.unitPrice!)! * Float(basket.qty!)
        }
        

        weak var PaymentSelectionViewController =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentOption") as? PaymentOptionsViewController
        PaymentSelectionViewController?.title = language.paymentOptionsTitle
        PaymentSelectionViewController?.selectedShopArrayIndex = selectedShopArrayIndex
        PaymentSelectionViewController?.totalAmount = calculatedPrice
        PaymentSelectionViewController?.currencySymbol = selectedItemCurrencySymbol
        PaymentSelectionViewController?.currencyShortForm = selectedItemCurrencyShortForm
        PaymentSelectionViewController?.selectedShopId = selectedShopId
        self.navigationController?.pushViewController(PaymentSelectionViewController!, animated: true)
        
        updateBackButton()
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    func animateTableView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.tableView?.frame.origin = self.defaultValue
        }, completion: nil)
    }
    
    fileprivate func moveOffScreen() {
        tableView?.frame.origin = CGPoint(x: (tableView?.frame.origin.x)!,
                                          y: (tableView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }


}

extension BasketViewController : BasketTotalAmountUpdateDelegate {
    func updateTotalAmount(_ amount: Float, reloadAll : Bool) {
        
        amountLabel.text = language.total +  String(amount) + selectedItemCurrencySymbol
        
        if(reloadAll) {
            basketItems.removeAll()
            loadBasket()
            tableView.reloadData()
        }
    }
}
