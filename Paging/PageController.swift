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
    var totalPages = 20
    var cardsCount = 2
    let spacing = 20
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blue
        collectionView.decelerationRate = .fast
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
        let bounds = scrollView.bounds
        let xTarget = targetContentOffset.pointee.x
        let cardsSlotCount = cardsCount
        
        //as we have two cards we divide the total width add padding b/w cards
        let padding = CGFloat((cardsCount-1) * spacing)
        let offset = (bounds.width-padding)/CGFloat(cardsSlotCount) + CGFloat(spacing)

        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x >= 0 {
            print("left")
            if currentCardIndex == 0 { return }
            
            //when dragging too much left side beyond left boundary
            var targetCardIndex = max(Int(xTarget/CGFloat(offset))-cardsSlotCount, 0)
         
            //check if user swipes fast and target index is way ahead than the current, rerset to current-cardsSlotCount
            targetCardIndex = min(max(targetCardIndex, currentCardIndex-cardsSlotCount), totalPages-cardsSlotCount)
            
            //set targetCardIndex to current card index
            currentCardIndex = targetCardIndex
            
            //calculate new target offset based on offset
            let newTarget = CGFloat(targetCardIndex) * CGFloat(offset)
            targetContentOffset.pointee.x = newTarget
        } else {
           print("right")
            if totalPages-cardsCount == currentCardIndex { return }
            
            var targetCardIndex = Int(xTarget/CGFloat(offset))+cardsSlotCount
                        
            //check if user swipes fast and target index is way ahead than the current, rerset to current+cardsCount
            targetCardIndex = min(min(targetCardIndex, currentCardIndex+cardsSlotCount), totalPages-cardsSlotCount)
            
            //set targetCardIndex to current card index
            currentCardIndex = targetCardIndex
            
            //calculate new target offset based on offset
            let newTargetOffsetX = CGFloat(targetCardIndex) * offset
            targetContentOffset.pointee.x = newTargetOffsetX
        }
    }
}
