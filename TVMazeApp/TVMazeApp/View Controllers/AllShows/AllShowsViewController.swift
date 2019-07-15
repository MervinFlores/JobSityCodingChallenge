//
//  AllShowsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage

class AllShowsViewController: BaseViewController, SearchBarDelegate{

    @IBOutlet weak var collectionViewMostPopular: UICollectionView!
    @IBOutlet weak var collectionViewRecentlyAdded: UICollectionView!
    @IBOutlet weak var collectionViewClassicals: UICollectionView!
    @IBOutlet weak var collectionViewTopCartoons: UICollectionView!
    
    //Search
    @IBOutlet weak var collectionViewSearchOptions: UICollectionView!
    
    @IBOutlet weak var labelMostPopular: UILabel!
    @IBOutlet weak var labelRecentlyAdded: UILabel!
    @IBOutlet weak var labelClassicals: UILabel!
    @IBOutlet weak var labelTopCartoons: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    let mainCellIdentifier = "ShowsCell"
    let searchCellIdentifier = "searchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.alpha = 1
        self.searchView.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupUI(){
        self.regularNavBar(title: "All Shows", isSearchAvailable: true)
        self.searchBarDelegate = self
//        self.nameLabels()
        
    }
    
    func textToSearch(_ searchText: String) {
        if searchText.isEmpty{
            self.mainView.alpha = 1
            self.searchView.alpha = 0
        } else {
            self.mainView.alpha = 0
            self.searchView.alpha = 1
        }
    }

}

extension AllShowsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewSearchOptions{
            return CGSize(width: collectionView.frame.size.width/5, height: collectionView.frame.size.height/5)
        } else {
            return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = self.mainCellIdentifier
        
        if collectionView == self.collectionViewSearchOptions{
            cellIdentifier = self.searchCellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GeneralCustomCollectionViewCell
        
        cell.fillCell("Split", "https://images-na.ssl-images-amazon.com/images/I/41AK%2B6G1sNL._SY445_.jpg")
        
        return cell
    }
}

class GeneralCustomCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var imageViewItem: UIImageView!
    
    var currentCellActor: ActorSearchBean?
    
    func fillCell(_ name: String, _ imageURL: String){
        self.imageViewItem.af_setImage(withURL: URL.init(string: imageURL)!)
    }
    
    func fillActorCellInfo(_ actor: ActorSearchBean){
        self.currentCellActor = actor
        if let imageActor = actor.actor?.image{
            self.imageViewItem.af_setImage(withURL: URL(string: imageActor.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
        }
        
    }
    
}
