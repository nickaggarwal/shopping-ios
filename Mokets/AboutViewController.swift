//
//  AboutViewController.swift
//  Mokets
//
//  Created by PPH-MacMini on 13/6/17.
//  Copyright © 2017 Panacea-soft. All rights reserved.
//

import Alamofire


class AboutViewController : UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var aboutTitle: UILabel!
    @IBOutlet weak var aboutDesc: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var aboutEmail: UIButton!
    
    @IBOutlet weak var aboutPhone: UIButton!
    
    @IBOutlet weak var aboutWebSite: UIButton!
    var aboutImages = [ImageModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loadAboutData()
        
        let aboutImageTap = UITapGestureRecognizer(target: self, action: #selector(AboutViewController.AboutImageTapped(_:)))
        aboutImageTap.numberOfTapsRequired = 1
        aboutImageTap.numberOfTouchesRequired = 1
        self.aboutImage.addGestureRecognizer(aboutImageTap)
        self.aboutImage.isUserInteractionEnabled = true
    }
    
    @objc func AboutImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.ended){
            let imgSliderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlider") as? ImageSliderViewController
            self.navigationController?.pushViewController(imgSliderViewController!, animated: true)
            imgSliderViewController?.itemImages = self.aboutImages
            updateBackButton()
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        let screenSize: CGRect = UIScreen.main.bounds
        aboutDesc.sizeToFit()
        scrollView.contentSize = CGSize(width:screenSize.width, height:aboutDesc.frame.height + CGFloat(500))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.aboutPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        self.navigationController!.navigationBar.tintColor = UIColor.white;
        
    }
    
    func loadAboutData() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        _ = Alamofire.request(APIRouters.GetAbout()).responseCollection {
            (response: DataResponse<[About]>) in
            
            _ = EZLoadingActivity.hide()
            
            if response.result.isSuccess {
                
                if let about: [About] = response.result.value {
                    
                    self.bindAboutData(about[0])
                    
                    if(about[0].images.count > 0) {
                        for image in about[0].images {
                            let oneImage = ImageModel(image: image)
                            self.aboutImages.append(oneImage)
                            
                        }
                    }
                    
                }
                
            }
            
        }
    }
    
    func bindAboutData(_ aboutData:About) {
        
        aboutTitle.text = aboutData.title
        aboutDesc.text = aboutData.desc
        aboutEmail.setTitle(" " + aboutData.email!, for: .normal)
        aboutPhone.setTitle(" " + aboutData.phone!, for: .normal)
        aboutWebSite.setTitle(" " + aboutData.website!, for: .normal)
        
        if aboutData.images[0].path != nil {
            let coverImageName =  aboutData.images[0].path! as String
            let imageURL = configs.imageUrl + coverImageName
            aboutImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
            
        }
        
    }
    
}


