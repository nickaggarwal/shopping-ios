//
//  TransactionHistoryTableViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire

class TransactionHistoryTableViewController : UITableViewController {
    
    var loginUserId: Int = 0
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var trans = [TransactionModel]()
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        loadLoginUserId()
        loadTransaction()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        defaultValue = tableView?.frame.origin
        animateTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
        let tran = trans[(indexPath as NSIndexPath).row]
        cell.configure(tran.id, transStatus: tran.transactionStatus, total: tran.totalAmount + tran.currencySymbol)
        
        cell.transactionNo.alpha = 0
        cell.totalAmount.alpha = 0
        cell.transactionStatus.alpha = 0
        cell.transIcon.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            cell.transactionNo.alpha = 1.0
            cell.totalAmount.alpha = 1.0
            cell.transactionStatus.alpha = 1.0
            cell.transIcon.alpha = 1.0
        }, completion: nil)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as! TransactionCell
        
        let tranDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransDetail") as? TransactionHistoryDetailViewController
        tranDetailViewController?.title = language.transactionHistoryDetail
        tranDetailViewController?.allTrans = trans
        tranDetailViewController?.rowIndex = (indexPath as NSIndexPath).row
        
        self.navigationController?.pushViewController(tranDetailViewController!, animated: true)
        
        updateBackButton()
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.transactionHistory
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func loadTransaction() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.UserTransactionHistory(loginUserId)).responseCollection {
            (response: DataResponse<[Transaction]>) in
            
            _ = EZLoadingActivity.hide()
            
            if response.result.isSuccess {
                
                    if let trans: [Transaction] = response.result.value {
    
                        for tran in trans {
                         
                            let oneTran = TransactionModel(transData: tran)
                            
                            self.trans.append(oneTran)
                        }
                        
                        self.tableView.reloadData()
    
    
                    } else {
                        print(response)
                    }
            }
            
            
        }
        
    }
    
    func loadLoginUserId() {
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
            loginUserId = Int(dict.object(forKey: "_login_user_id") as! String)!
        } else {
            print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func animateTableView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.tableView?.frame.origin = self.defaultValue
        }, completion: nil)
    }
    
    fileprivate func moveOffScreen() {
        tableView?.frame.origin = CGPoint(x: (tableView?.frame.origin.x)!,
                                          y: (tableView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}
