//
//  TransactionHistoryViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class TransactionHistoryDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var allTrans = [TransactionModel]()
    var rowIndex: Int = 0
    var transModel : TransactionModel? = nil
    var transDetail: TransactionDetail? = nil
    var defaultValue: CGPoint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get selected transaction model
        transModel = allTrans[rowIndex]
        
        // set datasource and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // init the pinterest layout
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.numberOfColumns = 1
            layout.bottomPadding = 100
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transModel!.transactionDetail.count + 1 // Need to add 1 because transaction info will show in first cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionHeaderCell", for: indexPath) as! TransactionHeaderCell
            cell.configure(transModel!)
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionDetailCell", for: indexPath) as! TransactionDetailCell
            
            cell.configure((transModel?.transactionDetail[indexPath.item - 1].itemName)!,
                           price: (transModel?.transactionDetail[indexPath.item - 1].unitPrice)! + (transModel?.currencySymbol)!,
                           qty: (transModel?.transactionDetail[indexPath.item - 1].qty)!,
                           attribute: (transModel?.transactionDetail[indexPath.item - 1].itemAttribute)!)
            
            return cell
        }
        
    }
    
}

extension TransactionHistoryDetailViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        
        // No image, So return 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        if indexPath.item == 0 {
            return getTransactionInfoHeight(indexPath: indexPath)
        }else {
            return 100
        }
    }
    
    func getTransactionInfoHeight (indexPath: IndexPath) -> CGFloat {
        let transInfoTopMargin : CGFloat  = 12
        let transInfoHeight : CGFloat  = 73
        let transInfoBottomMargin : CGFloat  = 19
        let lineBreakHeight : CGFloat  = 1
        let lineBreakBottomMargin : CGFloat  = 19
        
        let headingLabel : CGFloat  = 21
        let headingCount : CGFloat  = 4
        let headingLabelTotal : CGFloat  = headingLabel * headingCount
        
        let paddingHeight : CGFloat  = 5
        let paddingCount : CGFloat  = 8
        let paddingTotal : CGFloat  = paddingHeight * paddingCount
        
        let AddressPaddingLeft : CGFloat = 37
        let AddressPaddingRight : CGFloat = 20
        
        let bottomMargin : CGFloat = 40
        
        // Prepare for estimate label height
        let approximateWidthOfBioTextView = collectionView.frame.width - AddressPaddingLeft - AddressPaddingRight
        let size = CGSize(width: approximateWidthOfBioTextView, height : 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        
        // Est Phone height
        let estimatePhoneFrame  = NSString(string: (transModel?.phone)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estPhoneHeight : CGFloat = estimatePhoneFrame.height
        
        // Est Email height
        let estimateEmailFrame = NSString(string: (transModel?.email)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estEmailHeight : CGFloat = estimateEmailFrame.height
        
        // Est Billing Address height
        let estimateBillingFrame = NSString(string: (transModel?.billingAddress)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estBillingHeight : CGFloat = estimateBillingFrame.height
        
        // Est Delivery Address height
        let estimateDeliveryFrame = NSString(string: (transModel?.deliveryAddress)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estDeliveryHeight : CGFloat = estimateDeliveryFrame.height
        
        let cellHeight = transInfoTopMargin +
            transInfoHeight +
            transInfoBottomMargin +
            lineBreakHeight +
            lineBreakBottomMargin +
            headingLabelTotal +
            paddingTotal +
            estPhoneHeight +
            estEmailHeight +
            estBillingHeight +
            estDeliveryHeight +
        bottomMargin
        
        return cellHeight
    }
    
}


