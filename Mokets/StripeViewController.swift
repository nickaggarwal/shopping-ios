//
//  StripeViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 5/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Alamofire

class StripeViewController: UIViewController, STPPaymentCardTextFieldDelegate{
    
    var basketItems = [BasketSchema]()
    var transArray = [[String:AnyObject]]()
    var loginUserDeliveryAddress: String = ""
    var loginUserBillingAddress: String = ""
    var loginUserEmail: String = ""
    var loginUserPhone: String = ""
    var loginUserId:Int = 0
    var checkoutCurrencyShortForm: String = ""
    var selectedPaymentOption: String = ""
    var totalAmount: Float = 0.0
    var selectedShopId: Int!
    var selectedShopArrayIndex: Int!
    
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    
    override func viewDidLoad() {
        
        Stripe.setDefaultPublishableKey(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].stripePublishableKey)
        self.hideKeyboardWhenTappedAround()
    
    }
    
    
    @IBAction func pay(_ sender: AnyObject) {
        let card:STPCardParams = paymentTextField.cardParams
        STPAPIClient.shared().createToken(withCard: card) { (token, error) -> Void in
            if let error = error  {
                print(error)
            } else if let token = token {
                self.createBackendChargeWithToken(token) { status in
                    
                    if status == PKPaymentAuthorizationStatus.failure {
                        
                    }
                    
                }
            }
        }
        
        /* --> Old Code <--
         if let card:STPCardParams = paymentTextField.cardParams{
            STPAPIClient.shared().createToken(withCard: card) { (token, error) -> Void in
                if let error = error  {
                    print(error)
                } else if let token = token {
                    self.createBackendChargeWithToken(token) { status in
                    }
                }
            }
         }
         */
    }
    
    func createBackendChargeWithToken(_ token: STPToken, completion: @escaping (PKPaymentAuthorizationStatus) -> ()) {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        let url = URL(string: configs.mainUrl + configs.stripePayment)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        //let body = "stripeToken=\(token.tokenId)"
        //&shopId=\(selectedShopId)
        let body = "stripeToken=\(token.tokenId)&amount=\(totalAmount)&currency=\(checkoutCurrencyShortForm)&shopId=\(selectedShopId!)"
        print(body)
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        //let configuration = URLSessionConfiguration.ephemeral
        
        //TOFIX
        //let session = URLSession.shared(configuration: configuration)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.failure)
                print("Fail to charge")
            } else {
                
                if ((data) != nil) {
                  
                    let backToString = String(data: data!, encoding: String.Encoding.utf8) as String!
                    
                    if let serverResp = backToString {
                        print(serverResp)
                        
                        if serverResp == "payment_not_ok" {
                            completion(PKPaymentAuthorizationStatus.failure)
                           //self.orderFailed()
                            DispatchQueue.main.async {
                                self.orderFailed()
                            }
                            
                        }else {
                            completion(PKPaymentAuthorizationStatus.success)
                            print("Successfully Charegd")
                            print(PKPaymentAuthorizationStatus.self)
                            //Order Need to Submit Own Server
                            self.orderSubmitToServer()
                        }
                    }
                    
                }
            }
        }) 
        task.resume()
    }
    
    func orderFailed() {
        _ = EZLoadingActivity.hide()
        _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: language.orderFailMessage, style: AlertStyle.warning)
    }
    
    func orderSubmitToServer() {
        loadBasket()
        
        let orders: Array<[String:AnyObject]> = transArray
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: orders, options:[])
            let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            print(dataString)
            
            let params: [String: AnyObject] = [
                "orders": dataString
                
            ]
            
            _ = Alamofire.request(APIRouters.SubmitTransaction(params)).responseObject{
                
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
                            
                            _ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessMessage,
                                style: AlertStyle.success, buttonTitle: "Okay")
                            {
                                (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    
                                    //Clean Basket
                                    BasketTable.deleteByShopId(String(self.selectedShopId))
                                    
                                    //Clean Attribute TODO:TP
                                    //AttributeTable.deleteByShopId(String(self.selectedShopId))
                                    
                                    //Load Home Page
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                            
                            
                            
                        } else {
                            _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: language.orderFailMessage, style: AlertStyle.warning)
                            _ = EZLoadingActivity.hide()
                        }
                    }
                } else {
                    print(response)
                    _ = EZLoadingActivity.hide()
                }
 

            }
            
            
        } catch {
            print("JSON serialization failed:  \(error)")
            _ = EZLoadingActivity.hide()
        }
        transArray.removeAll()
    }
    
    func loadBasket() {
        
        for basket in BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)) {
            
            basketItems.append(basket)
            let data : Dictionary<String, AnyObject> = [
                "item_id" : basket.itemId! as AnyObject,
                "shop_id" : basket.shopId! as AnyObject,
                "unit_price" : basket.unitPrice! as AnyObject,
                "discount_percent" : basket.discountPercent! as AnyObject,
                "name" : basket.name! as AnyObject,
                "qty" : String(basket.qty!) as AnyObject,
                "user_id" : basket.userId! as AnyObject,
                "payment_trans_id" : "" as AnyObject,
                "total_amount" : totalAmount as AnyObject,
                "basket_item_attribute" : basket.selectedAttribute! as AnyObject,
                "payment_method" : "\(selectedPaymentOption)" as AnyObject,
                "email" : "\(loginUserEmail)" as AnyObject,
                "phone" : "\(loginUserPhone)" as AnyObject,
                "delivery_address" : "\(loginUserDeliveryAddress)" as AnyObject,
                "billing_address" : "\(loginUserBillingAddress)" as AnyObject,
                "platform" : "IOS" as AnyObject
            ]
            
             transArray.append(data)
           
        }
    }
    

    
    
}
