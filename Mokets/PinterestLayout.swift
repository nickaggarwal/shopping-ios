//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by ernesto on 01/06/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
protocol PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth:CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayoutAttributes:UICollectionViewLayoutAttributes {
    var photoHeight: CGFloat = 0.0
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? PinterestLayoutAttributes {
            if( attributtes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}


class PinterestLayout: UICollectionViewLayout {
    var delegate:PinterestLayoutDelegate!
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    var column = 0
    var yCacheOffset = [CGFloat]()
    var bottomPadding : CGFloat = 0
    fileprivate var cache = [PinterestLayoutAttributes]()
    fileprivate var contentHeight:CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    override func prepare() {
        
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
            if(!yCacheOffset.isEmpty){
                yOffset = yCacheOffset
            }
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                if((indexPath as NSIndexPath).row >= cache.count){
                    
                    let featureCell = false
                    let width = columnWidth - cellPadding * 2
                    var photoHeight : CGFloat
                    var annotationHeight :CGFloat
                        photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                        annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                    let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    
                    var insetFrame :CGRect
                    insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
                    attributes.photoHeight = photoHeight
                    attributes.frame = insetFrame
                
                    
                    cache.append(attributes)
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height
                    
                    if(featureCell) {
                        column += 1
                        yOffset[column] = yOffset[column] + height
                        column = 0
                    }else{
                        if column >= (numberOfColumns - 1) {
                            
                            column = 0
                            
                        }else {
                            
                            column += 1
                            
                            
                        }
                    }
                    self.yCacheOffset = yOffset
                    
                }else{
                    
                    let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
                    attributes.photoHeight = self.cache[(indexPath as NSIndexPath).row].photoHeight
                    attributes.frame = self.cache[(indexPath as NSIndexPath).row].frame
                }
            }
        
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: (contentHeight + bottomPadding))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}


