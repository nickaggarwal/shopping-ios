//
//  Common.swift
//  Mokets
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

open class Common {

    static let instance: Common = Common()
    public init(){}
    
    open func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    open func getLoginUserInfoPlist() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = (documentsDirectory as NSString).appendingPathComponent("LoginUserInfo.plist")
        return path
    }
    
    open func circleImageView(_ image:UIImageView) ->UIImageView {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.backgroundColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        return image
    }
    
    open func setTextViewBorderColor(_ txtView: UITextView)-> UITextView {
        txtView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        txtView.layer.borderWidth = 1.0
        txtView.layer.cornerRadius = 5
        return txtView
    }
    
    func isUserLogin()-> Bool {
        let plistPath = Common().getLoginUserInfoPlist()
        var loginUserId: Int = 0
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                }
                catch{
                
                }
                
                
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
            
            if(dict.object(forKey: "_login_user_id") != nil) {
            
                if(dict.object(forKey: "_login_user_id") as! String == "") {
                    loginUserId = 0
                } else {
                    loginUserId = Int((dict.object(forKey: "_login_user_id") as! NSString) as String)!
                }
                
                if(loginUserId != 0) {
                    return true
                } else {
                    return false
                }
                
            } else {
                return false
            }
            
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
        
        return false
    }
    
    func loadBackgroundImage(_ view: UIView)-> UIView {
        if let patternImage = UIImage(named: "Background") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        return view
    }
    
    
    func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    /*******************************
     * Function related with images
     *******************************/
    func saveImage(_ image: UIImage, path: String) -> Bool {
        let pngImageData = UIImagePNGRepresentation(image)
        let result = (try? pngImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        return result
    }
    
    func loadImageFromPath(_ path: String) -> UIImage? {
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        if data != nil {
            let image = UIImage(data: data!)!
            return image
        }
        
        return nil
    }
    
    func deleteImageFromPath(_ path: String) {
        // Create a FileManager instance
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func scaleUIImageToSize(_ image: UIImage, size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func getImageSize(_ size: CGSize) -> CGSize{
        let limitWidth :CGFloat = 250
        var convertedSize : CGSize = size
        var scale :CGFloat = 0
        
        if size.width > limitWidth {
            scale = size.width / limitWidth
            
            convertedSize.width /= scale
            convertedSize.height /= scale
        }
        
        return convertedSize
    }
    
    // Documents directory
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return documentsFolderPath
    }
    // File in Documents directory
    open func fileInDocumentsDirectory(_ filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }
    
}

// to allow use of .stringByAppendingPathComponent method in Swift 2
extension String {
    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}

// To dismiss the keyboard when click outside of text field
// Usage.
// extends the UITextFieldDelegate in class
// copy the following code to viewDidLoad
// self.hideKeyboardWhenTappedAround()
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
