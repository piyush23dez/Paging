//
//  HomeCell.swift
//  Paging
//
//  Created by Piyush Sharma on 4/22/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    var vc = PageController()
    let layout = UICollectionViewFlowLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout.scrollDirection = .horizontal
        vc = PageController(collectionViewLayout: layout)
        vc.view.backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(in parent: UIViewController) {
        parent.addChild(vc)
        vc.view.frame = contentView.bounds
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vc.view)
        vc.view.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        vc.view.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        vc.didMove(toParent: parent)
    }

}
