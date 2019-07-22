//
//  AllShowsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage
import MBProgressHUD

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
    var progressIndicator: MBProgressHUD?
    
    var customIndex = 0
    let mostPopularIds = [82,169,27436,30770,29191,567,2993,197,17861,305]
    let recentlyAddedIds = [3594,28270,39141,30202,39319,27436,29191]
    let topCartoonsIds = [83,216,2565,215,538,84,112]
    let classicalsIds = [66,118,431,676,618,988,4131,582,110]
    
    var topCartoonsShows = TopCartoonsShow()
    var mostPopularShows = MostPopularShows()
    var recentlyAddedShows = RecentlyAddedShows()
    var classicalsShows = ClassicalShows()
    
    
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
        
        self.getMostPopularShowBy(id: self.mostPopularIds[customIndex])
        self.progressIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.progressIndicator?.mode = .determinateHorizontalBar
        self.progressIndicator?.label.text = "Loading Most Popular Shows..."
    }
    
    
    //MARK: - GET Most Popular Show By
    private func getMostPopularShowBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let mostPopularShowsSaved = container.values(
            MostPopularShows.self,
            matching: .all
        )
        
        if mostPopularShowsSaved.count > 0 {
            var isContained = false
            for show in mostPopularShowsSaved.values().first!.shows!{
                if show.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.mostPopularIds.count - 1){
                    self.customIndex += 1
                    self.getMostPopularShowBy(id: self.mostPopularIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
                        self.customIndex = 0
                        self.mostPopularShows = mostPopularShowsSaved.values().first!
                        self.collectionViewMostPopular.reloadData()
                        self.getRecentlyAddedShowBy(id: self.recentlyAddedIds[self.customIndex])
                    }
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getShowDetails(showID: id) { (response) in
            switch response {
            case .success(let showResponse):
                var allMostPopularShows = MostPopularShows.init(shows: [showResponse])
                
                if mostPopularShowsSaved.count > 0 {
                    allMostPopularShows = mostPopularShowsSaved.values().first!
                    var isContained = false
                    for show in allMostPopularShows.shows!{
                        if show.id == showResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        allMostPopularShows.shows?.append(showResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(allMostPopularShows, update: .modified)
                }
                
                if self.customIndex < (self.mostPopularIds.count - 1){
                    self.customIndex += 1
                    self.getMostPopularShowBy(id: self.mostPopularIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
                    self.progressIndicator?.progress = 0.0
                    self.progressIndicator?.label.text = "Loading Recently Added Shows..."
                    self.customIndex = 0
                    self.mostPopularShows = mostPopularShowsSaved.values().first!
                    self.collectionViewMostPopular.reloadData()
                    self.getRecentlyAddedShowBy(id: self.recentlyAddedIds[self.customIndex])
                    return
                }
                
            default: break
            }
        }
    }
    
    
    //MARK: - GET Recently Added Shows
    private func getRecentlyAddedShowBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let recentlyAddedShowsSaved = container.values(
            RecentlyAddedShows.self,
            matching: .all
        )
        
        if recentlyAddedShowsSaved.count > 0 {
            var isContained = false
            for show in recentlyAddedShowsSaved.values().first!.shows!{
                if show.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.recentlyAddedIds.count - 1){
                    self.customIndex += 1
                    self.getRecentlyAddedShowBy(id: self.recentlyAddedIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = 0.0
                        self.progressIndicator?.label.text = "Loading Classicals Shows..."
                        self.customIndex = 0
                        self.recentlyAddedShows = recentlyAddedShowsSaved.values().first!
                        self.collectionViewRecentlyAdded.reloadData()
                        self.getClassicalShowBy(id: self.classicalsIds[self.customIndex])
                    }
                    return
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getShowDetails(showID: id) { (response) in
            switch response {
            case .success(let showResponse):
                var allAddedRecentlyShows = RecentlyAddedShows.init(shows: [showResponse])
                
                if recentlyAddedShowsSaved.count > 0 {
                    allAddedRecentlyShows = recentlyAddedShowsSaved.values().first!
                    var isContained = false
                    for show in allAddedRecentlyShows.shows!{
                        if show.id == showResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        allAddedRecentlyShows.shows?.append(showResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(allAddedRecentlyShows, update: .modified)
                }
                if self.customIndex < (self.recentlyAddedIds.count - 1){
                    self.customIndex += 1
                    self.getRecentlyAddedShowBy(id: self.recentlyAddedIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = 0.0
                    self.progressIndicator?.label.text = "Loading Classicals Shows..."
                    self.customIndex = 0
                    self.recentlyAddedShows = recentlyAddedShowsSaved.values().first!
                    self.collectionViewRecentlyAdded.reloadData()
                    self.getClassicalShowBy(id: self.classicalsIds[self.customIndex])
                    return
                }
                
            default: break
            }
        }
    }
    
    
    //MARK: - GET Classicals Shows
    private func getClassicalShowBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let classicalsShowsSaved = container.values(
            ClassicalShows.self,
            matching: .all
        )
        
        if classicalsShowsSaved.count > 0 {
            var isContained = false
            for show in classicalsShowsSaved.values().first!.shows!{
                if show.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.recentlyAddedIds.count - 1){
                    self.customIndex += 1
                    self.getClassicalShowBy(id: self.classicalsIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = 0.0
                        self.progressIndicator?.label.text = "Loading Top Cartoons..."
                        self.customIndex = 0
                        self.classicalsShows = classicalsShowsSaved.values().first!
                        self.collectionViewClassicals.reloadData()
                        self.getTopCartoonBy(id: self.classicalsIds[self.customIndex])
                    }
                    return
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getShowDetails(showID: id) { (response) in
            switch response {
            case .success(let showResponse):
                var allClassicalShows = ClassicalShows.init(shows: [showResponse])
                
                if classicalsShowsSaved.count > 0 {
                    allClassicalShows = classicalsShowsSaved.values().first!
                    var isContained = false
                    for show in allClassicalShows.shows!{
                        if show.id == showResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        allClassicalShows.shows?.append(showResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(allClassicalShows, update: .modified)
                }
                if self.customIndex < (self.classicalsIds.count - 1){
                    self.customIndex += 1
                    self.getClassicalShowBy(id:self.classicalsIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = 0.0
                    self.progressIndicator?.label.text = "Loading Top Cartoons..."
                    self.customIndex = 0
                    self.classicalsShows = classicalsShowsSaved.values().first!
                    self.collectionViewClassicals.reloadData()
                    self.getTopCartoonBy(id: self.classicalsIds[self.customIndex])
                    return
                }
                
            default: break
            }
        }
    }
    
    //MARK: - GET Top Cartoons
    private func getTopCartoonBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.topCartoonsIds.count))
        }
        
        let container = try! Container()
        
        let topCartoonsSaved = container.values(
            TopCartoonsShow.self,
            matching: .all
        )
        
        if topCartoonsSaved.count > 0 {
            var isContained = false
            for show in topCartoonsSaved.values().first!.shows!{
                if show.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.topCartoonsIds.count - 1){
                    self.customIndex += 1
                    self.getTopCartoonBy(id: self.topCartoonsIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = 1
                        self.progressIndicator?.hide(animated: true)
                        self.customIndex = 0
                        self.topCartoonsShows = topCartoonsSaved.values().first!
                        self.collectionViewTopCartoons.reloadData()
                    }
                    return
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getShowDetails(showID: id) { (response) in
            switch response {
            case .success(let showResponse):
                var allTopCartoons = TopCartoonsShow.init(shows: [showResponse])
                
                if topCartoonsSaved.count > 0 {
                    allTopCartoons = topCartoonsSaved.values().first!
                    var isContained = false
                    for show in allTopCartoons.shows!{
                        if show.id == showResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        allTopCartoons.shows?.append(showResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(allTopCartoons, update: .modified)
                }
                if self.customIndex < (self.topCartoonsIds.count - 1){
                    self.customIndex += 1
                    self.getClassicalShowBy(id:self.classicalsIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = 1
                    self.progressIndicator?.hide(animated: true)
                    self.customIndex = 0
                    self.topCartoonsShows = topCartoonsSaved.values().first!
                    self.collectionViewTopCartoons.reloadData()
                    return
                }
                
            default: break
            }
        }
    }
    
    //MARK: - GET Search
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
        let showDetailsViewController = UIStoryboard.ShowDetails().instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        self.view.showLoading()
        var showID = 0
        if collectionView == self.collectionViewSearchOptions{
            showID = currentCell.currentCellShow?.show?.id ?? 0
        } else {
            showID = currentCell.currentShow?.id ?? 0
        }
        
        GeneralManager.getShowDetails(showID: showID) { (response) in
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case self.collectionViewSearchOptions:
            return self.searchedShows?.count ?? 0
        case self.collectionViewMostPopular:
            return self.mostPopularShows.shows?.count ?? 0
        case self.collectionViewRecentlyAdded:
            return self.recentlyAddedShows.shows?.count ?? 0
        case self.collectionViewClassicals:
            return self.classicalsShows.shows?.count ?? 0
        case self.collectionViewTopCartoons:
            return self.topCartoonsShows.shows?.count ?? 0
        default:
            return 0
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
        case self.collectionViewMostPopular:
            cell.fillShowMainCellInfo(self.mostPopularShows.shows![indexPath.row])
        case self.collectionViewRecentlyAdded:
            cell.fillShowMainCellInfo(self.recentlyAddedShows.shows![indexPath.row])
        case self.collectionViewClassicals:
            cell.fillShowMainCellInfo(self.classicalsShows.shows![indexPath.row])
        case self.collectionViewTopCartoons:
            cell.fillShowMainCellInfo(self.topCartoonsShows.shows![indexPath.row])
        default:
            break
        }
        
        return cell
    }
}

class GeneralCustomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelTitleItem: UILabel!
    
    var currentCellActor: ActorSearchBean?
    var currentCellShow: ShowSearchedBean?
    
    var currentShow: ShowBean?
    var currentActor: Actor?
    
    func fillCell(_ name: String, _ imageURL: String){
        self.imageViewItem.af_setImage(withURL: URL.init(string: imageURL)!)
    }
    
    func fillShowMainCellInfo(_ show: ShowBean){
        self.currentShow = show
        
        if let imageShow = show.image {
            self.imageViewItem.af_setImage(withURL: URL(string: imageShow.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewItem.contentMode = .scaleAspectFit
        }
    }
    
    func fillActorMainCellInfo(_ actor: Actor){
        self.currentActor = actor
        
        if let imageActor = actor.image {
            self.imageViewItem.af_setImage(withURL: URL(string: imageActor.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewItem.contentMode = .scaleAspectFit
        }
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
    
    func fillFavoriteActorCellInfo(_ actor: Actor){
        self.currentActor = actor
        if let imageActor = actor.image{
            self.imageViewItem.af_setImage(withURL: URL(string: imageActor.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewItem.contentMode = .scaleAspectFit
        }
        self.labelTitleItem.text = actor.name
    }
    
    func fillFavoriteShowCellInfo(_ show: ShowBean){
        self.currentShow = show
        if let imageShow = show.image{
            self.imageViewItem.af_setImage(withURL: URL(string: imageShow.medium!)!)
        } else {
            self.imageViewItem.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewItem.contentMode = .scaleAspectFit
        }
        self.labelTitleItem.text = show.name
    }
    
}
