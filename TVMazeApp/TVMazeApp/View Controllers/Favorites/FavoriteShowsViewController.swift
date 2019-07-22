//
//  FavoriteShowsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import UIKit

class FavoriteShowsViewController: BaseViewController {
    
    @IBOutlet weak var collectionViewSearchOptions: UICollectionView!
    let searchCellIdentifier = "searchCell"
    @IBOutlet weak var viewEmpty: UIView!
    
    var favoriteShows = [ShowBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.collectionViewSearchOptions.frame.size.width/3, height: self.collectionViewSearchOptions.frame.size.width/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionViewSearchOptions.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let container = try! Container()
        
        let favoritesSaved = container.values(
            Favorites.self,
            matching: .all
            ).values()
        
        if favoritesSaved.count <= 0{
            
        } else {
            self.favoriteShows = favoritesSaved.first!.shows!
            self.collectionViewSearchOptions.reloadData()
        }
        
        self.regularNavBar(title: "My Shows", isSearchAvailable: false)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FavoriteShowsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.viewEmpty.isHidden = !(self.favoriteShows.count == 0)
        
        return self.favoriteShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! GeneralCustomCollectionViewCell
        let showDetailsViewController = UIStoryboard.ShowDetails().instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        
        self.view.showLoading()
        GeneralManager.getShowDetails(showID:  currentCell.currentShow?.id ?? 0) { (response) in
            self.view.dissmissLoading()
            switch response {
            case .success(let showBean):
                showDetailsViewController.showDetails = showBean
                self.navigationController?.pushViewController(showDetailsViewController, animated: true)
            default:
                break
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchCellIdentifier, for: indexPath) as! GeneralCustomCollectionViewCell
        
        cell.fillFavoriteShowCellInfo(self.favoriteShows[indexPath.row])
        
        return cell
    }
}
