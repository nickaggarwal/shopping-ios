//
//  BasketCell.swift
//  Mokets
//
//  Created by PPH-MacMini on 3/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire
import SQLite

//protocol ButtonCellDelegate {
//    func cellTapped(cell: BasketCell)
//}

class BasketCell: UITableViewCell {
    //var buttonDelegate: ButtonCellDelegate?
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var subTotalAmount: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var attributeLabel: UILabel!
    
    var request : Alamofire.Request?
    var subTotal = 0.0;
    var discountPercent = 0.0
    var calculatedPrice = 0.0
    var totalAmount: Float = 0.0
    var id: Int64 = 0
    var selectedShopId = ""
    var selectedItemId = ""
    var selectedItemQty:Int64 = 0
    var basketSchema = BasketSchema()
    var loginUserId: Int = 0
    var selectedCurrencySymbol = ""
    var selectedAttribute = ""
    var selectedAttributeIds = ""
    weak var basketTotalAmountUpdateDelegate : BasketTotalAmountUpdateDelegate!
    
    
    func configure(_ id: Int64, shopId: String, itemId: String, itemTitle: String, itemPrice: String,  itemQty: Int64, itemCurrencySymbol: String, itemDiscountPerdent: String, itemCoverImage: String, userId: Int, selectedAttribute: String, selectedAttributeIds: String) {
        title.text = itemTitle
        
        //calculatedPrice = Double(itemPrice)! - (Double(itemDiscountPerdent)! * Double(itemPrice)!)
        self.id = id
        calculatedPrice = Double(itemPrice)!
        subTotal = calculatedPrice * Double(itemQty)
        subTotalAmount.text =  String(subTotal) + itemCurrencySymbol
        
        price.text = language.price + itemPrice
        qty.text = language.qty + String(itemQty)
        discountPercent = Double(itemDiscountPerdent)!
        
        selectedShopId = shopId
        selectedItemId = itemId
        selectedItemQty = itemQty
        loginUserId = userId
        self.selectedAttribute = selectedAttribute
        self.selectedAttributeIds = selectedAttributeIds
        
        if selectedAttribute == "" {
            attributeLabel.text = "( N.A )"
        }else {
            attributeLabel.text = "(" + selectedAttribute + ")"
        }
        
        selectedCurrencySymbol = itemCurrencySymbol
    }
    
    
  
    
    
    @IBAction func increaseQty(_ sender: AnyObject) {
        
        selectedItemQty += 1
        qty.text = language.qty + String(selectedItemQty)
        
        subTotal = calculatedPrice * Double(selectedItemQty)
        subTotalAmount.text =  String(subTotal) + selectedCurrencySymbol
        
        basketSchema.qty = selectedItemQty
        BasketTable.updateQtyById(basketSchema, selectedShopId: String(selectedShopId), selectedId: id)
        
        totalAmount = 0.0
        
        for basket in BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)) {
            totalAmount += Float(basket.unitPrice!)! * Float(basket.qty!)
        }
        
        self.basketTotalAmountUpdateDelegate.updateTotalAmount(totalAmount, reloadAll: false)
        
    }
    
    
    @IBAction func decreaseQty(_ sender: AnyObject) {
        
        selectedItemQty -= 1
        
        if(selectedItemQty > 0) {
            qty.text = language.qty + String(selectedItemQty)
            subTotal = calculatedPrice * Double(selectedItemQty)
            subTotalAmount.text =  String(subTotal) + selectedCurrencySymbol
            
            
            basketSchema.qty = selectedItemQty
            BasketTable.updateQtyById(basketSchema, selectedShopId: String(selectedShopId), selectedId: id)
            
            totalAmount = 0.0
            
            for basket in BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)) {
                totalAmount += Float(basket.unitPrice!)! * Float(basket.qty!)
            }
            
            self.basketTotalAmountUpdateDelegate.updateTotalAmount(totalAmount, reloadAll: false)
        } else {
            
            _ = SweetAlert().showAlert(language.basketTitle, subTitle: language.basketMessage, style: AlertStyle.warning)
        }
        

    }
    

    
    
}
