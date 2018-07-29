//
//  ShopProfileViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 28/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

class ShopProfileViewController: UIViewController {
    
    var selectedShopId:Int = 0
    var selectedShopLat: String!
    var selectedShopLng: String!
    var selectedShopName: String!
    var selectedShopDesc: String!
    var selectedShopPhone: String!
    var selectedShopEmail: String!
    var selectedShopAddress: String!
    var selectedShopCoverImage: String!
    
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopDescription: UILabel!
    @IBOutlet weak var shopPhone: UILabel!
    @IBOutlet weak var shopEmail: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var shopMap: MKMapView!
    
    @IBOutlet weak var shopCoverImage: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    var defaultValue: CGPoint!
    
    
    override func viewDidLoad() {
        
        if(selectedShopName == nil || selectedShopName == ""){
            loadShopDataFromServer()
        }else {
            bindShopData()
            loadMap()
        }
        
        labelTapRegister()
        
        contentView.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    func bindShopData() {
        shopName.text = selectedShopName
        shopDescription.text = selectedShopDesc
        shopPhone.text = selectedShopPhone
        shopEmail.text = selectedShopEmail
        shopAddress.text = selectedShopAddress
        
        if(selectedShopCoverImage != nil && selectedShopCoverImage != "") {
            let coverImageName =  selectedShopCoverImage! as String
            let imageURL = configs.imageUrl + coverImageName
            shopCoverImage.image = nil
            
            self.shopCoverImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    
                }else {
                    print("Error in loading image" + msg)
                }
            }
        }
    }
    
    func loadShopDataFromServer() {
        
        // show loading in very first time only
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        _ = Alamofire.request(APIRouters.GetShopByID(Int(selectedShopId))).responseObject {
            (response: DataResponse<Shop>) in
            
            _ = EZLoadingActivity.hide()
            
            if response.result.isSuccess {
                if let shop: Shop = response.result.value {
                    
                    print("Shop Name : \(String(describing: shop.name))")
                  
                    self.selectedShopName       = shop.name
                    self.selectedShopDesc       = shop.desc
                    self.selectedShopPhone      = shop.phone
                    self.selectedShopEmail      = shop.email
                    self.selectedShopAddress    = shop.address
                    self.selectedShopLat        = shop.lat
                    self.selectedShopLng        = shop.lng
                    self.selectedShopCoverImage = shop.coverImageFile
                  
                    self.bindShopData()
                    self.loadMap()
                }
                
                //self.collectionView!.reloadData()
                
            } else {
                print(response)
                
            }
        }
    }
 
    func loadMap() {
 
        let location = CLLocationCoordinate2D(
            latitude: Double(selectedShopLat)!,
            longitude: Double(selectedShopLng)!
        )
        
        let span = MKCoordinateSpanMake(0.01 , 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        shopMap.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = selectedShopName
        annotation.subtitle = selectedShopAddress
        shopMap.addAnnotation(annotation)
 
    }
    
    func labelTapRegister() {
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(ShopProfileViewController.PhoneNoTapped(_:)))
        phoneTap.numberOfTapsRequired = 1
        phoneTap.numberOfTouchesRequired = 1
        self.shopPhone.addGestureRecognizer(phoneTap)
        self.shopPhone.isUserInteractionEnabled = true
        
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(ShopProfileViewController.EmailTapped(_:)))
        emailTap.numberOfTapsRequired = 1
        emailTap.numberOfTouchesRequired = 1
        self.shopEmail.addGestureRecognizer(phoneTap)
        self.shopEmail.isUserInteractionEnabled = true
        
    }
    
    
    @objc func PhoneNoTapped(_ sender:UITapGestureRecognizer) {
        let phoneNo : Int? = Int(shopPhone.text!)
        if let url = URL(string: "tel://\(String(describing: phoneNo))") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func EmailTapped(_ sender:UITapGestureRecognizer) {
        let email : Int? = Int(shopEmail.text!)
        if let url = URL(string: "mailto://\(String(describing: email))") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
            
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
                self.contentView.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}
