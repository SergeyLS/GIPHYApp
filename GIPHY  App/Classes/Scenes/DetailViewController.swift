//
//  DetailViewController.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import SwiftyGif

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var indicatorUI: UIActivityIndicatorView!
    
    
    var gifManager = SwiftyGifManager(memoryLimit:100)
    
    var gif: Gif?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GifManager.getGifDataOriginal(gif: gif) { [weak self] (dataGif) in
            
            guard let gifManager = self?.gifManager else {
                     return
            }
            
            DispatchQueue.main.async {
                let gifImage = UIImage(gifData: dataGif)
                self?.imageUI.setGifImage(gifImage, manager: gifManager, loopCount: -1)
                self?.indicatorUI.stopAnimating()
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
