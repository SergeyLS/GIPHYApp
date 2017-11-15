//
//  CollectionViewCell.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import SwiftyGif

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var indicatorUI: UIActivityIndicatorView!
    @IBOutlet weak var nameUI: UILabel!
    
    let gifManager = SwiftyGifManager(memoryLimit:100)
    
    func update(image: UIImage?, name: String = "") {
        if let imageToDisplay = image {
            indicatorUI.stopAnimating()
            imageUI.setGifImage(imageToDisplay, manager: self.gifManager, loopCount: -1)
            nameUI.text = name
        } else {
            indicatorUI.startAnimating()
            imageUI.image = nil
            nameUI.text = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageUI.image = nil
        nameUI.text = nil
        //update(image: nil)
    }
    

    
}
