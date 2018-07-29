//
//  ForgotPasswordViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class ForgotPasswordViewController : UIViewController, UITextFieldDelegate {
    var fromWhere: String = ""
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var userEmail: UITextField!
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var contentView: UIView!
    var defaultValue: CGPoint!
    
    @IBAction func loadLogin(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review") {
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("login")
        }
    }
    
    @IBAction func loadRegister(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review") {
            weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
            UserRegViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserRegViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("register")
        }
    }
    
    
    @IBAction func submitPassword(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(userEmail.text != "") {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params: [String: AnyObject] = [
                "email"  :  userEmail.text! as AnyObject
            ]
            
            _ = Alamofire.request(APIRouters.ResetPassword(params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        print(res.data)
                        _ = SweetAlert().showAlert(language.resetTitle, subTitle: language.resetSuccess, style: AlertStyle.success)
                        self.sendMessageDelegate?.returnmsg("login")
                        
                        self.dismissKeyboard()
                    }
                } else {
                    print(response)
                }
                
                _ = EZLoadingActivity.hide()
                
            }
        } else {
            _ = SweetAlert().showAlert(language.resetTitle, subTitle: language.userEmailEmpty, style: AlertStyle.warning)
        }
        
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        userEmail.alpha = 0
        btnSubmit.alpha = 0
        btnRegister.alpha = 0
        btnLogin.alpha = 0
        lblTitle.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItemFont()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userEmail = nil
    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.forgotTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func animateContentView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.contentView?.frame.origin = self.defaultValue
        }, completion: { finished in
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.userEmail.alpha = 1.0
                self.btnSubmit.alpha = 1.0
                self.btnRegister.alpha = 1.0
                self.btnLogin.alpha = 1.0
                self.lblTitle.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}

