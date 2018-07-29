//
//  SearchViewController.swift
//  Mokets
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import GoogleMobileAds


class SearchViewController: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchKeyword: UITextField!
    var defaultValue: CGPoint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var admobView: GADBannerView!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBAction func doSearch(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        let selectedValue = ShopsListModel.sharedManager.shops[pickerView.selectedRow(inComponent: 0)].id
        let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResult") as? SearchResultViewController
        self.navigationController?.pushViewController(resultViewController!, animated: true)
        resultViewController?.selectedCityId = Int(selectedValue)!
        resultViewController?.searchKeyword = searchKeyword.text
        updateBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
 
        
       /*TOFIX */
        if admobConfig.isEnabled == true {
            print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
            admobView.adUnitID = admobConfig.adUnitId
            
            admobView.rootViewController = self
            admobView.load(GADRequest())
        } else {
            admobView.isHidden = true
        }
   
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        self.searchKeyword.delegate = self;
        
        defaultValue = contentView?.frame.origin
        animateContentView()
        
        btnSearch.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func numberOfComponents(in shopPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ShopsListModel.sharedManager.shops.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ShopsListModel.sharedManager.shops[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = ShopsListModel.sharedManager.shops[row].name
        pickerLabel.font = UIFont(name: customFont.normalFontName , size: CGFloat(customFont.pickerFontSize)) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.searchPageTitle
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
                self.pickerView.alpha = 1.0
                self.searchKeyword.alpha = 1.0
                self.btnSearch.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}


//MARK: UITextField Delegate
extension SearchViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= 165
        print("TextField -165")
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y += 165
        print("TextField +165")
        return true
    }
}

