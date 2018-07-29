//
//  CheckoutConfirmViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 5/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire

class CheckoutConfirmViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var totalAmount: Float = 0.0
    var selectedShopArrayIndex: Int!
    var selectedPaymentOption: String = ""
    var loginUserId:Int = 0
    var loginUserName: String = ""
    var loginUserEmail: String = ""
    var loginUserPhone: String = ""
    var loginUserDeliveryAddress: String = ""
    var loginUserBillingAddress: String = ""
    var selectedShopId: Int!
    var checkoutCurrencySymbol: String = ""
    var checkoutCurrencyShortForm: String = ""
    var basketItems = [BasketSchema]()
    var placeholderDeliveryLabel : UILabel!
    var placeholderBillingLabel : UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var seletedPayment: UILabel!
    
    var transArray = [[String:AnyObject]]()
    
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var deliveryAddress: UITextView!
    @IBOutlet weak var billingAddress: UITextView!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        bindData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CheckoutConfirmViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CheckoutConfirmViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        placeholderDeliveryLabel = UILabel()
        placeholderBillingLabel = UILabel()
        
        addPlaceHolder(deliveryAddress, placeHolderText: "Delivery Address", placeholderLabel: placeholderDeliveryLabel)
        addPlaceHolder(billingAddress, placeHolderText: "Billing Address", placeholderLabel: placeholderBillingLabel)
        
        
        name.delegate = self
        email.delegate = self
        phone.delegate = self
        deliveryAddress.delegate = self
        billingAddress.delegate = self
       
    }
    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height + 70)
    }
    
    
    @IBAction func gotoPayment(_ sender: AnyObject) {
        
        
        if(phone.text! == "" || deliveryAddress.text! == "" || billingAddress.text! == "" || name.text! == "" || email.text! == "") {
            _ = SweetAlert().showAlert(language.checkoutConfirmationTitle,subTitle:language.userInfoRequired ,style:AlertStyle.warning)
        } else {
        
            switch selectedPaymentOption {
            
            case "stripe":
                checkoutWithStripe()
                break
                
            case "bank":
                checkoutWithBankTransfer()
                break
                
            case "cod":
                checkoutWithCOD()
                break
                
                
            default:
                break
            }
            
        }
 
    }
    
    func checkoutWithStripe() {
        weak var stripeViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Stripe") as? StripeViewController
        stripeViewController?.title = language.paymentTitle
        stripeViewController?.selectedShopId = selectedShopId
        stripeViewController?.checkoutCurrencyShortForm = checkoutCurrencyShortForm
        stripeViewController?.totalAmount = totalAmount
        stripeViewController?.loginUserDeliveryAddress = loginUserDeliveryAddress
        stripeViewController?.loginUserBillingAddress = loginUserBillingAddress
        stripeViewController?.loginUserEmail = loginUserEmail
        stripeViewController?.loginUserPhone = loginUserPhone
        stripeViewController?.loginUserId = loginUserId
        stripeViewController?.selectedPaymentOption = selectedPaymentOption
        stripeViewController?.selectedShopArrayIndex = selectedShopArrayIndex
        self.navigationController?.pushViewController(stripeViewController!, animated: true)
        updateBackButton()
    }
    
    func checkoutWithCOD() {
        orderSubmitToServer()
    }
    
    
    func checkoutWithBankTransfer() {
        orderSubmitToServer()
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
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            _ = Alamofire.request(APIRouters.SubmitTransaction(params)).responseObject{
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
                            print("... API Response Data ....")
                            print(resp.data)
                            _ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessMessage,
                                style: AlertStyle.success, buttonTitle: " OK ")
                            {
                                (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    
                                    //Clean Basket
                                    BasketTable.deleteByShopId(String(ShopsListModel.sharedManager.shops[self.selectedShopArrayIndex].id))
                                    
                                    //Clean Attribute Table TODO:TP
                                    //AttributeTable.deleteByShopId(String(ShopsListModel.sharedManager.shops[self.selectedShopArrayIndex].id))
                                    
                                    //Load Home Page
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                            }
                            
                        } else {
                            _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: language.orderFailMessage, style: AlertStyle.warning)
                        }
                    }
                } else {
                    _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: language.orderFailMessage, style: AlertStyle.warning)
                    print(response)
                }
            }
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        transArray.removeAll()
    }
    
    func bindData() {
        
        total.text = language.total + String(totalAmount) + checkoutCurrencySymbol + "(" + checkoutCurrencyShortForm + ")"
        
        switch selectedPaymentOption {
        case "stripe":
            seletedPayment.text = "Stripe"
            break
         
        case "bank":
            seletedPayment.text = "Bank Transfer"
            break
            
        case "cod":
            seletedPayment.text = "Cash On Delivery"
            break
            
        default: break
        }
        
        bindUserInfo()
        
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
      
    }
    @objc func keyboardWillHide(_ sender: Notification) {
       
    }
    
    func textFieldShouldReturn(_ UITextField: UITextField) -> Bool {
       
        self.view.endEditing(true)
        
        // Try to find next responder
        let nextTag = UITextField.tag + 1
        if let nextField = UITextField.superview?.viewWithTag(nextTag) as? UITextField {
            nextField.becomeFirstResponder()
        } else if let nextField2 = UITextField.superview?.viewWithTag(nextTag) as? UITextView {
            nextField2.becomeFirstResponder()
        } else{
            // Not found, so remove keyboard.
            //UITextField.resignFirstResponder()
            self.view.endEditing(true)
        }
        // Do not add a line break
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        if(text == "\n") {
            let nextTag = textView.tag + 1
            if let nextField = textView.superview?.viewWithTag(nextTag) as? UITextView {
                nextField.becomeFirstResponder()
            } else{
                // Not found, so remove keyboard.
                //textView.resignFirstResponder()
                self.view.endEditing(true)
            }
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= 165
        print("TextField -165")
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y += 165
        print("TextField +165")
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.frame.origin.y -= 215
        print("TextView -215")
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView)  {
        self.view.frame.origin.y += 215
        print("TextView +215")
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        switch (textView) {
        case deliveryAddress:
            placeholderDeliveryLabel.isHidden = !deliveryAddress.text.isEmpty
            break
        
        case billingAddress:
            placeholderBillingLabel.isHidden = !billingAddress.text.isEmpty
            break
            
        default: break
        }
    }
    
    func addPlaceHolder(_ textView: UITextView, placeHolderText: String, placeholderLabel: UILabel) {
        textView.delegate = self
        placeholderLabel.text = placeHolderText
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: textView.font!.pointSize)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: textView.font!.pointSize / 3)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
    }
    
    func bindUserInfo() {
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
            loginUserName         = dict.object(forKey: "_login_user_username") as! String
            loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
            loginUserPhone        = dict.object(forKey: "_login_user_phone") as! String
            loginUserDeliveryAddress = dict.object(forKey: "_login_user_delivery_address") as! String
            loginUserBillingAddress  = dict.object(forKey: "_login_user_billing_address") as! String
            
            name.text = loginUserName
            email.text = loginUserEmail
            phone.text = loginUserPhone
            deliveryAddress.text = loginUserDeliveryAddress
            billingAddress.text = loginUserBillingAddress
            
            
        } else {
            print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
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
                "delivery_address" : deliveryAddress.text! as AnyObject,
                "billing_address" : billingAddress.text! as AnyObject,
                "total_amount" : totalAmount as AnyObject,
                "basket_item_attribute" : basket.selectedAttribute! as AnyObject,
                "basket_item_attribute_id" : basket.selectedAttribute! as AnyObject,
                "payment_method" : selectedPaymentOption as AnyObject,
                "email" : email.text! as AnyObject,
                "phone" : phone.text! as AnyObject,
                "platform" : "IOS" as AnyObject
            ]
            transArray.append(data)
        }

        
    }
}
