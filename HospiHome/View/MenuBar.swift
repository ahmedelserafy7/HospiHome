//
//  MenuBar.swift
//  HospiHome
//
//  Created by Elser_10 on 5/1/20.
//  Copyright © 2020 Elser_10. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let cellId = "cellId"
    var homeController: HomeViewController?
    let specialists = ["Dentistry", "Surgery", "Allergy", "Psychiatry", "Neurology"]
    func showCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        homeController?.hideWhenSwipe()
    }
    
    func selectDefaultItem() {
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition())
    }
}

extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuBarCell
        cell.nameLabel.text = specialists[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        selectDefaultItem()
    }
}
