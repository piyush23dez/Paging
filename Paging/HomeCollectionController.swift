//
//  ViewController.swift
//  Paging
//
//  Created by Piyush Sharma on 4/22/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class HomeCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .green
        collectionView.showsHorizontalScrollIndicator = false
        setup()
    }
    
    func setup(){
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reusable")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
            cell.backgroundColor = .purple
            (cell as? HomeCell)?.display(in: self)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusable", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: view.bounds.size.height * 0.33)
    }    
}


