//
//  UserProfileViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 17/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileViewController: UIViewController {
    
    weak var sendMessageDelegate : SendMessageDelegate?
    var loginUserId: Int =  0
    var loginUserName: String = ""
    var loginUserProfilePhoto: String = ""
    var loginUserEmail: String = ""
    var loginUserAboutMe: String = ""
    var downloadedPhotoURLs: [URL]?
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtAboutMe: UITextView!
    @IBOutlet weak var imgUserProfileBG: UIImageView!
    
    
   
    @IBOutlet var contentView: UIView!
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        bindUserInfo()
        _ = Common.instance.circleImageView(imgUserProfile)
        txtAboutMe.setContentOffset(CGPoint.zero, animated: false)
        
        imgUserProfile.alpha = 0
        lblName.alpha = 0
        lblEmail.alpha = 0
        txtAboutMe.alpha = 0
        imgUserProfileBG.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItem()
       
    }
    
    func setNavigationItem() {
        self.navigationController?.navigationBar.topItem?.title = language.profilePageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    func saveImage(_ image: UIImage?){
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        
        if image != nil {
            // Save it to our Documents folder
            let result = Common.instance.saveImage(image!, path: imagePath)
            print("Image saved? Result: \(result)")
            
        }
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
            loginUserProfilePhoto = dict.object(forKey: "_login_user_profile_photo") as! String
            loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
            loginUserAboutMe      = dict.object(forKey: "_login_user_about_me") as! String
            
            lblName.text = loginUserName
            lblEmail.text = loginUserEmail
            txtAboutMe.text = loginUserAboutMe
            txtAboutMe.isEditable = false
            
            let imageURL = configs.imageUrl + loginUserProfilePhoto
            self.imgUserProfile.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    self.saveImage(image)
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
            
            // set imagePath
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            let loadedImage = Common.instance.loadImageFromPath(imagePath)
            if loadedImage != nil {
                print("Image loaded: \(loadedImage!)")
                self.imgUserProfile.image = loadedImage
                self.imgUserProfileBG.image = loadedImage
            }
            
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
        
    }
    
    
    func animateContentView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.contentView?.frame.origin = self.defaultValue
        }, completion: { finished in
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.imgUserProfile.alpha = 1.0
                self.lblName.alpha = 1.0
                self.lblEmail.alpha = 1.0
                self.txtAboutMe.alpha = 1.0
                self.imgUserProfileBG.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}
