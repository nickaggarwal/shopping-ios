//
//  PaymentOptionsViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 5/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class PaymentOptionsViewController : UIViewController {
    
    var selectedShopArrayIndex: Int!
    var totalAmount: Float = 0.0
    var currencySymbol: String = ""
    var currencyShortForm: String = ""
    var selectedShopId: Int!
    
    @IBOutlet var contentView: UIScrollView!
    var defaultValue: CGPoint!
    
    @IBOutlet weak var paypalView: UIView!
    @IBOutlet weak var paypalViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var CODView: UIView!
    @IBOutlet weak var CODViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var StripeView: UIView!
    @IBOutlet weak var StripeViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var BTView: UIView!
    @IBOutlet weak var BTViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnStripeGo: UIButton!
    @IBOutlet weak var btnCODGo: UIButton!
    @IBOutlet weak var btnBankGo: UIButton!
    
    override func viewDidLoad() {
        //if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].paypalEnabled == "0") {
            paypalView.isHidden = true
            paypalViewHeight.constant = 0
        //}
        
        if selectedShopArrayIndex == nil {
            var i=0
            for shop in ShopsListModel.sharedManager.shops {
                
                if Int(shop.id)! == selectedShopId {
                    selectedShopArrayIndex = i
                    break
                }
                
                i += 1
            }
        }
        
        if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].stripeEnabled == "0") {
            StripeView.isHidden = true
            StripeViewHeight.constant = 0
        }
        
        
        if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].codEnabled == "0") {
            CODView.isHidden = true
            CODViewHeight.constant = 0
        }
        
        if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].bankTransferEnabled == "0") {
            BTView.isHidden = true
            BTViewHeight.constant = 0
        }
        
        btnStripeGo.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        btnCODGo.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        btnBankGo.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        CODView.alpha = 0
        BTView.alpha = 0
        StripeView.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    @IBAction func BTGo(_ sender: AnyObject) {
        loadCheckoutConfirm("bank")
    }
    
    
    @IBAction func CODGo(_ sender: AnyObject) {
        loadCheckoutConfirm("cod")
    }
    
    
    @IBAction func StripeGo(_ sender: AnyObject) {
        loadCheckoutConfirm("stripe")
    }
    
    
    
    @IBAction func PaypalGo(_ sender: AnyObject) {
        loadCheckoutConfirm("paypal")
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func loadCheckoutConfirm(_ paymentOption: String) {
        weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
        ConfirmViewController?.title = language.checkoutConfirmationTitle
        ConfirmViewController?.totalAmount = totalAmount
        ConfirmViewController?.selectedPaymentOption = paymentOption
        ConfirmViewController?.selectedShopArrayIndex = selectedShopArrayIndex
        ConfirmViewController?.checkoutCurrencySymbol = currencySymbol
        ConfirmViewController?.checkoutCurrencyShortForm = currencyShortForm
        ConfirmViewController?.selectedShopId = selectedShopId
        self.navigationController?.pushViewController(ConfirmViewController!, animated: true)
        updateBackButton()

    }
    
    func animateContentView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.contentView?.frame.origin = self.defaultValue
        }, completion: { finished in
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.CODView.alpha = 1.0
                self.StripeView.alpha = 1.0
                self.BTView.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}
