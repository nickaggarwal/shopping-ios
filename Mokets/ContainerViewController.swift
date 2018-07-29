//
//  ProfileViewControllers.swift
//  Mokets
//
//  Created by Panacea-soft on 10/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

@objc protocol SendMessageDelegate: class {
    func returnmsg(_ msg:String)
    @objc optional func returnCode(_ code:integer_t)
}

class ProfileViewController: UIViewController, SendMessageDelegate{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        
        if(Common.instance.isUserLogin()) {
            loadComponent("ComponentUserProfile")
            addNavigationMenuItem()
        } else {
            loadComponent("ComponentLogin")
        }
        
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func addNavigationMenuItem() {
        let btnNavi = UIButton()
        btnNavi.setImage(UIImage(named: "Setting-Lite"), for: UIControlState())
        btnNavi.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnNavi.addTarget(self, action: #selector(ProfileViewController.loadProfileEdit(_:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnNavi
        
        self.navigationItem.rightBarButtonItems = [itemNavi]
    }
    
    @objc func loadProfileEdit(_ sender: UIBarButtonItem) {
        loadComponent("ComponentUserProfileEdit")
        self.title = "Profile Edit"
        self.navigationItem.rightBarButtonItems = nil
    }
    
    func loadComponent(_ componentName: String) {
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: componentName)
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        
        if let loginView = self.currentViewController as? LoginViewController {
            loginView.sendMessageDelegate = self
            self.addSubview(loginView.view, toView: self.containerView)
        } else if let registerView = self.currentViewController as? RegisterViewController {
            registerView.sendMessageDelegate = self
            self.addSubview(registerView.view, toView: self.containerView)
        } else if let forgotView = self.currentViewController as? ForgotPasswordViewController {
            forgotView.sendMessageDelegate = self
            self.addSubview(forgotView.view, toView: self.containerView)
        } else if let profileView = self.currentViewController as? UserProfileViewController {
            profileView.sendMessageDelegate = self
            self.addSubview(profileView.view, toView: self.containerView)
        }
        
        else {
            self.addSubview(self.currentViewController!.view, toView: self.containerView)
        }
        
    }
    
    func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func returnmsg(_ msg:String){
        
        if(msg == "register") {
            self.title = "Register"
            loadComponent("ComponentRegister")
        } else if(msg == "login") {
            self.title = "Login"
            loadComponent("ComponentLogin")
        } else if(msg == "forgot") {
            self.title = "Forgot Password"
            loadComponent("ComponentForgot")
        } else if(msg == "profile") {
            self.title = "Profile"
            loadComponent("ComponentUserProfile")
            addNavigationMenuItem()
        }
        
    }
    
    
    
}
