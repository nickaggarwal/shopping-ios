//
//  MenuListController.swift
//  Mokets
//
//  Created by Panacea-soft on 2/9/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit

class MenuListController: UITableViewController {
    
    var userLoggedIn : Bool = false {
        didSet {
            updateMenu()
        }
    }
    
    @IBOutlet weak var homeCell: UITableViewCell!
    @IBOutlet weak var searchCell: UITableViewCell!
    @IBOutlet weak var pushNotiCell: UITableViewCell!
    @IBOutlet weak var profileCell: UITableViewCell!
    @IBOutlet weak var myFavCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var transactionHistoryCell: UITableViewCell!
    
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var search: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var favourite: UILabel!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var transactionHistory: UILabel!
    
    override func viewDidLoad() {
        if(Common.instance.isUserLogin()) {
            self.userLoggedIn = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        home.text = language.homeMenu
        search.text = language.searchMenu
        profile.text = language.ProfileMenu
        favourite.text = language.favouriteMenu
        logout.text = language.logoutMenu
        transactionHistory.text = language.transactionHistory
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Logout
        if((indexPath as NSIndexPath).row == 6){
            self.revealViewController().revealToggle(nil)
            let rowToSelect:IndexPath = IndexPath(row: 0, section: 0);
            self.tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.none);
            self.userLoggedIn = false
            performSegue(withIdentifier: "CitiesListHome", sender: self)
            updatePlist()
            
            // Delete the profile image from local
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            Common.instance.deleteImageFromPath(imagePath)
        }
    }
    
    func updateMenu(){
        if userLoggedIn {
            myFavCell?.isHidden = false
            logoutCell?.isHidden = false
            transactionHistoryCell?.isHidden = false

        }else{
            transactionHistoryCell?.isHidden = true
            myFavCell?.isHidden = true
            logoutCell?.isHidden = true

        }

    }
    
    func updatePlist() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        
        dict.setObject("", forKey: "_login_user_id" as NSString)
        dict.setObject("", forKey: "_login_user_username" as NSString)
        dict.setObject("", forKey: "_login_user_email" as NSString)
        dict.setObject("", forKey: "_login_user_about_me" as NSString)
        dict.setObject("", forKey: "_login_user_profile_photo" as NSString)
        
        dict.write(toFile: plistPath, atomically: false)
        
    }
}
