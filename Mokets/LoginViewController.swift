//
//  LoginViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 13/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    var fromWhere:String = ""
    var selectedItemId:Int = 0
    var selectedShopId:Int = 0
    weak var reviewListRefreshReviewCountsDelegate : ReviewListRefreshReviewCountsDelegate!
    weak var itemDetailLoginUserIdDelegate : ItemDetailLoginUserIdDelegate!
    
    weak var sendMessageDelegate : SendMessageDelegate?
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var contentView: UIView!
    var defaultValue: CGPoint!
    
    @IBAction func loadRegister(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review" || self.fromWhere == "favourite" || self.fromWhere == "like" || self.fromWhere == "cart") {
            weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
            UserRegViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserRegViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("register")
        }
    }
    
    @IBAction func loadForgotPassword(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review" || self.fromWhere == "favourite" || self.fromWhere == "like" || self.fromWhere == "cart") {
            weak var passworForgotViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as? ForgotPasswordViewController
            passworForgotViewController!.fromWhere = "review"
            self.navigationController?.pushViewController(passworForgotViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("forgot")
        }
    }
    
    @IBAction func submitLogin(_ sender: AnyObject) {
        
        // Dimiss keyboard
        self.dismissKeyboard()
        
        self.dismissKeyboard()
        
        if txtEmail.text == "" || txtPassword.text == "" {
            _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.blankInputLogin, style: AlertStyle.warning)
        } else if txtEmail.text != ""{
            
            if(Common.instance.isValidEmail(txtEmail.text!)) {
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                let param: [String: AnyObject] = ["email": txtEmail.text! as AnyObject, "password": txtPassword.text! as AnyObject]
                _ = Alamofire.request(APIRouters.UserLogin(param)).responseObject {
                    (response: DataResponse<User>) in
                    if response.result.isSuccess {
                        
                        if let user = response.result.value {
                            
                            // Normal ( From Profile Login)
                            if self.fromWhere == "" {
                            
                                let imageURL = configs.imageUrl + user.profilePhoto!
                                
                                
                                let img : UIImageView = UIImageView()
                                
                                img.loadImage(urlString: imageURL) { (status, url, image, msg) in
                                    if status == STATUS.success {
                                        self.saveImage(image)

                                        
                                        // Update menu
                                        (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                                        
                                        // Add the user info to local
                                        self.addToPlist(user)
                                        
                                        // Open profile Page
                                        self.sendMessageDelegate?.returnmsg("profile")
                                        
                                        _ = EZLoadingActivity.hide()
                                        
                                        _ = self.navigationController?.popViewController(animated: true)
                                        
                                    } else {
                                        _ = EZLoadingActivity.hide()
                                        
                                        _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.warning)
                                        print(response)
                                    }
                                }

                                
                            }else{ // For others
                                
                                // Add the user info to local
                                self.addToPlist(user)
                                
                                let imageURL = configs.imageUrl + user.profilePhoto!
                                
                                let img : UIImageView = UIImageView()
                                
                                img.loadImage(urlString: imageURL) { (status, url, image, msg) in
                                    if status == STATUS.success {
                                        self.saveImage(image)
                                        
                                    }
                                }
                                // Update menu
                                (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                                
                                if(self.fromWhere == "review") {
                                    _ = self.navigationController?.popViewController(animated: true)
                                    let reviewFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEntryViewController") as? ReviewEntryViewController
                                    reviewFormViewController?.reviewListRefreshReviewCountsDelegate = self.reviewListRefreshReviewCountsDelegate
                                    reviewFormViewController?.selectedItemId = self.selectedItemId
                                    reviewFormViewController?.selectedShopId = self.selectedShopId
                                    self.navigationController?.pushViewController(reviewFormViewController!, animated: true)
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = EZLoadingActivity.hide()
                                    
                                } else if (self.fromWhere == "favourite") {
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                } else if (self.fromWhere == "like") {
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                } else if (self.fromWhere == "cart") {
                                
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                
                                }
                                
                            }
                           
                            
                        }else{
                            _ = EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.warning)
                            print(response)
                        }
                        
                    } else {
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.warning)
                        print(response)
                    }
                }
                
            } else {
                _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.emailValidation, style: AlertStyle.warning)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        txtEmail.alpha = 0
        txtPassword.alpha = 0
        btnSubmit.alpha = 0
        btnRegister.alpha = 0
        btnForgot.alpha = 0
        lblTitle.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    func saveImage(_ image: UIImage?){
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        
        if image != nil {
            // Save it to our Documents folder
            let result = Common.instance.saveImage(image!, path: imagePath)
            print("Image saved? Result: \(result)")
            
        }
    }
    func addToPlist(_ user: User) {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        let userID : Int = Int(user.id!)!
        dict.setObject("\(userID)" , forKey: "_login_user_id" as NSString)
        dict.setObject(user.username ?? "", forKey: "_login_user_username" as NSString)
        dict.setObject(user.email ?? "", forKey: "_login_user_email" as NSString)
        dict.setObject(user.aboutMe ?? "", forKey: "_login_user_about_me" as NSString)
        dict.setObject(user.profilePhoto ?? "default_user_profile.png", forKey: "_login_user_profile_photo" as NSString)
        dict.setObject(user.phone ?? "", forKey: "_login_user_phone" as NSString)
        dict.setObject(user.deliveryAddress ?? "", forKey: "_login_user_delivery_address" as NSString)
        dict.setObject(user.billingAddress ?? "", forKey: "_login_user_billing_address" as NSString)
        
        dict.write(toFile: plistPath, atomically: false)
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.LoginTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
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
                self.txtEmail.alpha = 1.0
                self.txtPassword.alpha = 1.0
                self.btnSubmit.alpha = 1.0
                self.btnRegister.alpha = 1.0
                self.btnForgot.alpha = 1.0
                self.lblTitle.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}

