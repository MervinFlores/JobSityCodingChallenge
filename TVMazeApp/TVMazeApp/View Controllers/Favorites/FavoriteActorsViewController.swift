//
//  FavoriteActorsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit

class FavoriteActorsViewController: BaseViewController {
    
    @IBOutlet weak var collectionViewSearchOptions: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    
    let searchCellIdentifier = "searchCell"
    var favoriteActors = [Actor]()
    
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
        
        self.regularNavBar(title: "My Actors", isSearchAvailable: false)
        
        let container = try! Container()
        let favoritesSaved = container.values(
            Favorites.self,
            matching: .all
            ).values()
        
        if favoritesSaved.count <= 0{
            
        } else {
            self.favoriteActors = favoritesSaved.first!.actors!
            self.collectionViewSearchOptions.reloadData()
        }
    }
    
}

extension FavoriteActorsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewEmpty.isHidden = !(self.favoriteActors.count == 0)
        return self.favoriteActors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! GeneralCustomCollectionViewCell
        let actorDetailsViewController = UIStoryboard.ActorDetails().instantiateViewController(withIdentifier: "ActorsDetailsViewController") as! ActorsDetailsViewController
        self.view.showLoading()
        GeneralManager.getActorDetails(actorID: currentCell.currentActor?.id ?? 0) { (response) in
            self.view.dissmissLoading()
            switch response {
            case .success(let actorBean):
                actorDetailsViewController.currentActor = actorBean
                self.navigationController?.pushViewController(actorDetailsViewController, animated: true)
            default:
                break
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.searchCellIdentifier, for: indexPath) as! GeneralCustomCollectionViewCell
        
        cell.fillFavoriteActorCellInfo(self.favoriteActors[indexPath.row])
        
        return cell
    }
}
