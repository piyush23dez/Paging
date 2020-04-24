//
//  PageController.swift
//  Paging
//
//  Created by Piyush Sharma on 4/22/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PageController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    var currentCardIndex = 0
    var totalPages = 19
    var cardsCount = 2
    let spacing = 20
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blue
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
     
    //stackoverflow.com/questions/42498129/adding-a-uiviewcontroller-inside-a-uicollectionview-cell
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let possibleCellIndexPath = collectionView.indexPathsForVisibleItems.min()
        coordinator.animate(alongsideTransition: { (context) in
        }) { (coordinator) in
            if let indexPath = possibleCellIndexPath {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            }
            self.collectionView.reloadData()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalPages
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PageCell
        cell?.textLabel.text = "\(indexPath.item)"
        cell?.backgroundColor = .orange
        return cell!
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = (cardsCount-1) * spacing
        return CGSize(width: ((collectionView.frame.size.width-CGFloat((padding)))/CGFloat(cardsCount)), height: collectionView.frame.size.height)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let bounds = scrollView.bounds
        let xTarget = targetContentOffset.pointee.x
        let cardsSlotCount = cardsCount
        
        //calculate spacing between cards based on cardsSlotCount
        let padding = CGFloat((cardsSlotCount-1) * spacing)
        
        //calculate initial offset for single card based on padding and width
        let offset = (bounds.width-padding)/CGFloat(cardsSlotCount) + CGFloat(spacing)
        
        //set default target offset x position as current card offset
        var pageX = CGFloat(currentCardIndex) * offset

        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            print("left")
            
            //check if dragged card disance is more than half card then only goto previous page
            let draggingX = pageX - offset/2
            if xTarget > draggingX && abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
                targetContentOffset.pointee.x = pageX
                return
            }
            
            //when dragging too much left side beyond left boundary
            var targetCardIndex = max(Int(xTarget/CGFloat(offset))-cardsSlotCount, 0)
         
            //check if user swipes fast and target index is way ahead than the current, rerset to current-cardsSlotCount
            targetCardIndex = min(max(targetCardIndex, currentCardIndex-cardsSlotCount), totalPages-cardsSlotCount)
            
            //set targetCardIndex to current card index
            currentCardIndex = targetCardIndex
            
            //calculate new target offset based on offset
            pageX = CGFloat(targetCardIndex) * CGFloat(offset)
            targetContentOffset.pointee.x = pageX
            
        } else if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x < 0 {
           print("right")
            
            //check if dragged card disance is more than half card then only goto next page
            let draggingX = pageX + offset/2
            if xTarget < draggingX && abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
                targetContentOffset.pointee.x = pageX
                return
            }
            
            var targetCardIndex = Int(xTarget/CGFloat(offset))+cardsSlotCount
                        
            //check if user swipes fast and target index is way ahead than the current, rerset to current+cardsCount
            targetCardIndex = min(min(targetCardIndex, currentCardIndex+cardsSlotCount), totalPages-cardsSlotCount)
            
            //set targetCardIndex to current card index
            currentCardIndex = targetCardIndex
            
            //calculate new target offset based on offset
            pageX = CGFloat(targetCardIndex) * offset
            targetContentOffset.pointee.x = pageX
        } else {
            print("current")
            targetContentOffset.pointee.x = pageX
        }
    }
    
    // Velocity is measured in points per millisecond.
       private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }
}
