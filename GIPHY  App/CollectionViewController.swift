//
//  CollectionViewController.swift
//  GIPHY  App
//
//  Created by Sergey Leskov on 7/16/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData
import SwiftyGif

class CollectionViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarUI: UISearchBar!
    
    
    lazy var fetchResultController: NSFetchedResultsController<Gif> = {
        let fetchRequest: NSFetchRequest<Gif> = Gif.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView
        collectionView.delegate = self
        collectionView.dataSource = self

        //search
         searchBarUI.delegate = self
  
        //fetchResultController
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //==================================================
    // MARK: - load
    //==================================================
      func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        GifManager.getFromAPI {
            DispatchQueue.main.async {
               UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
    }

    
    //==================================================
    // MARK: - Navigation
    //==================================================
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailGif"  {
            let destinationController = segue.destination as! DetailViewController
            destinationController.gif = sender as? Gif
        }
        
    }

}


//==============================================================
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//==============================================================

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (fetchResultController.sections != nil) ? fetchResultController.sections!.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var resultNumber: Int = 0
        if let sections = fetchResultController.sections, sections.count > section {
            let sectionInfo = sections[section]
            resultNumber = sectionInfo.numberOfObjects
        }
        return resultNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let gif = fetchResultController.object(at: indexPath) 
        cell.update(image: nil)
        
         DispatchQueue.main.async {
            GifManager.getGifDataSmall(gif: gif) { (dataGif) in
                
                let gifImage = UIImage(gifData: dataGif)
                 cell.update(image: gifImage, name: gif.name!)
                
            }
        }

        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = fetchResultController.object(at: indexPath)
        self.performSegue(withIdentifier: "detailGif", sender: gif)
    }
}


//==================================================
// MARK: - BaseFetchTableViewController
//==================================================
extension CollectionViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //print("[CollectionViewController] reloadData: controller:didChange:at:for:newIndexPath:")
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }

}


//==================================================
// MARK: - UISearchBarDelegate
//==================================================
extension CollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            fetchResultController.fetchRequest.predicate =   nil
        } else {
            fetchResultController.fetchRequest.predicate =   NSPredicate(format:"name contains[cd] %@", searchText)
        }
        
        
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
        collectionView.reloadData()
        

    }
    
    
}



