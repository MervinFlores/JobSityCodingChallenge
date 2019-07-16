//
//  AllShowsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage

class AllShowsViewController: BaseViewController, SearchBarDelegate {

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
    
    var searchedShows: [ShowSearchedBean]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.alpha = 1
        self.searchView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
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
    
    private func setupUI(){
        self.regularNavBar(title: "All Shows", isSearchAvailable: true)
        self.searchBarDelegate = self
        
    }
    
    private func getShowsFromSearch(_ search: String){
        GeneralManager.getShowsFromSearch(query: search) { (response) in
            switch response {
            case .success(let shows):
                self.searchedShows = shows
            case .empty:
                self.searchedShows = nil
            case .error:
                break
            }
            self.collectionViewSearchOptions.reloadData()
        }
    }
    
    func textToSearch(_ searchText: String) {
        if searchText.isEmpty{
            self.mainView.alpha = 1
            self.searchView.alpha = 0
        } else {
            self.mainView.alpha = 0
            self.searchView.alpha = 1
            self.getShowsFromSearch(searchText)
        }
    }

}

extension AllShowsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! GeneralCustomCollectionViewCell
        if collectionView == self.collectionViewSearchOptions{
            let showDetailsViewController = UIStoryboard.ShowDetails().instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
            self.view.showLoading()
            GeneralManager.getShowDetails(showID: currentCell.currentCellShow?.show?.id ?? 0) { (response) in
                self.view.dissmissLoading()
                switch response {
                case .success(let showBean):
                    showDetailsViewController.showDetails = showBean
                    self.navigationController?.pushViewController(showDetailsViewController, animated: true)
                default:
                    break
                }
            }
        } else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionViewSearchOptions:
            return self.searchedShows?.count ?? 0
        default:
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewSearchOptions{
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height/2)
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
        
        switch collectionView{
        case self.collectionViewSearchOptions:
            cell.fillShowCellInfo(self.searchedShows![indexPath.row], true)
        default:
            cell.fillCell("Split", "https://images-na.ssl-images-amazon.com/images/I/41AK%2B6G1sNL._SY445_.jpg")
        }
        
        return cell
    }
}

class GeneralCustomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelTitleItem: UILabel!
    
    var currentCellActor: ActorSearchBean?
    var currentCellShow: ShowSearchedBean?
    
    func fillCell(_ name: String, _ imageURL: String){
        self.imageViewItem.af_setImage(withURL: URL.init(string: imageURL)!)
    }
    
    func fillShowCellInfo(_ show: ShowSearchedBean, _ isForSearch: Bool = false){
        self.currentCellShow = show
        if let imageShow = show.show?.image {
            self.imageViewItem.af_setImage(withURL: URL(string: imageShow.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewItem.contentMode = .scaleAspectFit
        }
        
        if isForSearch{
            self.labelTitleItem.text = show.show?.name
        }
    }
    
    func fillActorCellInfo(_ actor: ActorSearchBean, _ isForSearch: Bool = false){
        self.currentCellActor = actor
        if let imageActor = actor.actor?.image{
            self.imageViewItem.af_setImage(withURL: URL(string: imageActor.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewItem.contentMode = .scaleAspectFit
        }
        if isForSearch{
            self.labelTitleItem.text = actor.actor?.name
        }
    }
    
}
