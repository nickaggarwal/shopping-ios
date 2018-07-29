//
//  InquiryEntryViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 18/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class InquiryEntryViewController: UIViewController, UITextViewDelegate {
    
    var placeholderLabel : UILabel!
    var selectedItemId:Int = 0
    var selectedShopId:Int = 0
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var inquiryMessage: UITextView!
    
    @IBOutlet weak var submit: UIButton!
    var defaultValue: CGPoint!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func SubmitInquiry(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(userName.text != "" || userEmail.text != "" || inquiryMessage.text != "") {
            
            let params: [String : AnyObject] = [
                "name"   : userName.text! as AnyObject,
                "email"  : userEmail.text! as AnyObject,
                "message": inquiryMessage.text! as AnyObject,
                "shop_id": selectedShopId as AnyObject
            ]
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            _ = Alamofire.request(APIRouters.AddItemInquiry(selectedItemId, params)).responseObject{
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
                            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.inquirySentSuccess, style: AlertStyle.success)
                            self.cleanTextInput()
                        } else {
                            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.somethingWrong, style: AlertStyle.warning)
                        }
                    }else {
                        _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.somethingWrong, style: AlertStyle.warning)
                    }
                } else {
                    print(response)
                    _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.somethingWrong, style: AlertStyle.warning)
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.inquiryEmpty, style: AlertStyle.warning)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        addPlaceHolder()
        self.hideKeyboardWhenTappedAround()
        submit.backgroundColor =  Common.instance.colorWithHexString(configs.barColorCode)
        
        contentView.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        submit.setTitle(language.submit, for: UIControlState())
    }
    
    func addPlaceHolder() {
        inquiryMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = language.typeInquiryMessage
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: inquiryMessage.font!.pointSize)
        placeholderLabel.sizeToFit()
        inquiryMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: inquiryMessage.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !inquiryMessage.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func cleanTextInput() {
        userName.text = ""
        userEmail.text = ""
        inquiryMessage.text = ""
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.inquiryPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    func animateContentView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.contentView?.frame.origin = self.defaultValue
        }, completion: { finished in
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.contentView.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}
