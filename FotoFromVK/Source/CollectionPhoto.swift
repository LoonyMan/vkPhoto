//
//  CollectionPhoto.swift
//  FotoFromVK
//
//  Created by Mihail on 30.11.2018.
//  Copyright © 2018 Mihail. All rights reserved.
//

import UIKit
import Kingfisher



class CollectionPhoto: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       

    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_photo", for: indexPath) as! CellPhoto
        
        cell.Image1.kf.setImage(with: URL(string: "https://pp.userapi.com/c848632/v848632127/7b0d0/rsYo-5s-_WA.jpg"))
        cell.backgroundColor = UIColor.gray
        
        return cell
        
    }

}
