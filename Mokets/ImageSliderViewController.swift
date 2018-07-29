//
//  ImageSliderViewController.swift
//  Mokets
//
//  Created by Panacea-Soft on 19/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire

class ImageSliderViewController : UIViewController, UIPageViewControllerDataSource {
    
    var itemImages = [ImageModel]()
    weak var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.sliderPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
   func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if itemImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageImageController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageImageController
        
        if itemController.itemIndex+1 < itemImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    func getItemController(_ itemIndex: Int) -> PageImageController? {
        if itemIndex < itemImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemImageController") as! PageImageController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = itemImages[itemIndex].imageCoverName
            pageItemController.imageDesc = itemImages[itemIndex].imageDesc
            return pageItemController
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return itemImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
}
