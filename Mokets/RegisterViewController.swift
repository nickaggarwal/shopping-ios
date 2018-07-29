//
//  RegisterViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 13/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class RegisterViewController: UIViewController , UITextFieldDelegate{
    
    var fromWhere:String = ""
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    var defaultValue: CGPoint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    
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
    
    @IBAction func loadForgotPassword(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review") {
            weak var passworForgotViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as? ForgotPasswordViewController
            passworForgotViewController!.fromWhere = "review"
            self.navigationController?.pushViewController(passworForgotViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("forgot")
        }
    }
    
    @IBAction func submitUser(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(userName.text != "" && userPassword.text != "" && userEmail.text != "") {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params: [String: AnyObject] = [
                "username"  :  userName.text! as AnyObject,
                "email"     :  userEmail.text! as AnyObject,
                "password"  :  userPassword.text! as AnyObject,
                "about_me"  :  "" as AnyObject
            ]
            
            _ = Alamofire.request(APIRouters.AddAppUser(params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        
                        if res.status == "success" {
                            print(res.intData)
                            
                            // Update menu
                            (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                            
                            // Add the user info to local
                            let plistPath = Common.instance.getLoginUserInfoPlist()
                            let dict: NSMutableDictionary = [:]
                            
                            let userID : Int = Int(res.intData)
                            print("User ID \(userID)")
                            dict.setObject("\(userID)" , forKey: "_login_user_id" as NSString)
                            dict.setObject(self.userName.text ?? "", forKey: "_login_user_username" as NSString)
                            dict.setObject(self.userEmail.text ?? "", forKey: "_login_user_email" as NSString)
                            dict.setObject("", forKey: "_login_user_about_me" as NSString)
                            dict.setObject("default_user_profile.png", forKey: "_login_user_profile_photo" as NSString)
                            dict.setObject("", forKey: "_login_user_phone" as NSString)
                            dict.setObject("", forKey: "_login_user_delivery_address" as NSString)
                            dict.setObject("", forKey: "_login_user_billing_address" as NSString)
                            
                            dict.write(toFile: plistPath, atomically: false)
                            
                            
                            _ = SweetAlert().showAlert(language.registerTitle, subTitle: language.registerSuccess, style: AlertStyle.success)
                            self.sendMessageDelegate?.returnmsg("profile")
                        }else{
                            _ = SweetAlert().showAlert(language.registerTitle, subTitle: res.data, style: AlertStyle.warning)
                        }
                    }
                } else {
                    print(response)
                }
                
                _ = EZLoadingActivity.hide()
                
            }
        } else {
            _ = SweetAlert().showAlert(language.registerTitle, subTitle: language.userInputEmpty, style: AlertStyle.warning)
        }
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        userName.alpha = 0
        userEmail.alpha = 0
        userPassword.alpha = 0
        lblTitle.alpha = 0
        btnRegister.alpha = 0
        btnLogin.alpha = 0
        btnForgot.alpha = 0        
        
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItemFont()
    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.registerTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
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
                self.userName.alpha = 1.0
                self.userEmail.alpha = 1.0
                self.userPassword.alpha = 1.0
                self.lblTitle.alpha = 1.0
                self.btnRegister.alpha = 1.0
                self.btnLogin.alpha = 1.0
                self.btnForgot.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
   
    
}
