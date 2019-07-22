//
//  AllActorsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage
import MBProgressHUD

class AllActorsViewController: BaseViewController, SearchBarDelegate{
    
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
    
    var progressIndicator: MBProgressHUD?
    var searchedActorsResults: [ActorSearchBean]?
    var oscarsWinnersActors = OscarsWinnersActors()
    var mostPopularActors = MostPopularActors()
    var marvelHeroesActor = MarvelHeroesActors()
    var classicalsActors = ClassicalActors()
    
    var customIndex = 0
    let mostPopularIds = [72686,27638, 72402, 27020, 67873]
    let marvelIds = [85480,49567,71223,61478]
    let oscarsWinnersIds = [30745,70077,45775]
    let classicalsIds = [95711,143217, 211193]
    
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
        self.regularNavBar(title: "All Actors", isSearchAvailable: true)
        self.searchBarDelegate = self
        
        self.getMostPopularActorBy(id: self.mostPopularIds[customIndex])
        self.progressIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.progressIndicator?.mode = .determinateHorizontalBar
        self.progressIndicator?.label.text = "Loading Most Popular Actors..."
        
        
    }
    
    //MARK: - GET Most Popular Actor By
    private func getMostPopularActorBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let mostPopularActorsSaved = container.values(
            MostPopularActors.self,
            matching: .all
        )
        
        if mostPopularActorsSaved.count > 0 {
            var isContained = false
            for actor in mostPopularActorsSaved.values().first!.actors!{
                if actor.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.mostPopularIds.count - 1){
                    self.customIndex += 1
                    self.getMostPopularActorBy(id: self.mostPopularIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
                        self.customIndex = 0
                        self.mostPopularActors = mostPopularActorsSaved.values().first!
                        self.collectionViewMostPopular.reloadData()
                        self.getMarvelHeroesActorBy(id: self.marvelIds[self.customIndex])
                    }
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getActorDetails(actorID: id) { (response) in
            switch response {
            case .success(let actorResponse):
                var allMostPopularActors = MostPopularActors.init(actors: [actorResponse])
                
                if mostPopularActorsSaved.count > 0 {
                    allMostPopularActors = mostPopularActorsSaved.values().first!
                    var isContained = false
                    for actor in allMostPopularActors.actors!{
                        if actor.id == actorResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        allMostPopularActors.actors?.append(actorResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(allMostPopularActors, update: .modified)
                }
                
                if self.customIndex < (self.mostPopularIds.count - 1){
                    self.customIndex += 1
                    self.getMostPopularActorBy(id: self.mostPopularIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
                    self.customIndex = 0
                    self.progressIndicator?.label.text = "Loading Marvel Actors..."
                    self.mostPopularActors = mostPopularActorsSaved.values().first!
                    self.collectionViewMostPopular.reloadData()
                    self.getMarvelHeroesActorBy(id: self.marvelIds[self.customIndex])
                    return
                }
            default: break
            }
        }
    }
    
    //MARK: - GET Marvel Heroes Actor By
    private func getMarvelHeroesActorBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let marvelHeroesActorsSaved = container.values(
            MarvelHeroesActors.self,
            matching: .all
        )
        
        if marvelHeroesActorsSaved.count > 0 {
            var isContained = false
            for actor in marvelHeroesActorsSaved.values().first!.actors!{
                if actor.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.marvelIds.count - 1){
                    self.customIndex += 1
                    self.getMarvelHeroesActorBy(id: self.marvelIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.marvelIds.count))
                        self.customIndex = 0
                        self.marvelHeroesActor = marvelHeroesActorsSaved.values().first!
                        self.collectionViewRecentlyAdded.reloadData()
                        self.getClassicalActorBy(id: self.classicalsIds[self.customIndex])
                    }
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getActorDetails(actorID: id) { (response) in
            switch response {
            case .success(let actorResponse):
                var marvelHeroesActors = MarvelHeroesActors.init(actors: [actorResponse])
                
                if marvelHeroesActorsSaved.count > 0 {
                    marvelHeroesActors = marvelHeroesActorsSaved.values().first!
                    var isContained = false
                    for actor in marvelHeroesActors.actors!{
                        if actor.id == actorResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        marvelHeroesActors.actors?.append(actorResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(marvelHeroesActors, update: .modified)
                }
                
                if self.customIndex < (self.marvelIds.count - 1){
                    self.customIndex += 1
                    self.getMarvelHeroesActorBy(id: self.marvelIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.marvelIds.count))
                    self.customIndex = 0
                    self.progressIndicator?.label.text = "Loading Classical Actors..."
                    self.marvelHeroesActor = marvelHeroesActorsSaved.values().first!
                    self.collectionViewRecentlyAdded.reloadData()
                    self.getClassicalActorBy(id: self.classicalsIds[self.customIndex])
                    return
                }
            default: break
            }
        }
    }
    
    //MARK: - GET Classical Actors By
    private func getClassicalActorBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let classicalActorsSaved = container.values(
            ClassicalActors.self,
            matching: .all
        )
        
        if classicalActorsSaved.count > 0 {
            var isContained = false
            for actor in classicalActorsSaved.values().first!.actors!{
                if actor.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.classicalsIds.count - 1){
                    self.customIndex += 1
                    self.getClassicalActorBy(id: self.classicalsIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
                        self.customIndex = 0
                        self.classicalsActors = classicalActorsSaved.values().first!
                        self.collectionViewClassicals.reloadData()
                        self.getOscarsWinnerActorBy(id: self.oscarsWinnersIds[self.customIndex])
                    }
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getActorDetails(actorID: id) { (response) in
            switch response {
            case .success(let actorResponse):
                var classicalActors = ClassicalActors.init(actors: [actorResponse])
                
                if classicalActorsSaved.count > 0 {
                    classicalActors = classicalActorsSaved.values().first!
                    var isContained = false
                    for actor in classicalActors.actors!{
                        if actor.id == actorResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        classicalActors.actors?.append(actorResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(classicalActors, update: .modified)
                }
                
                if self.customIndex < (self.classicalsIds.count - 1){
                    self.customIndex += 1
                    self.getClassicalActorBy(id: self.classicalsIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.classicalsIds.count))
                    self.customIndex = 0
                    self.progressIndicator?.label.text = "Loading Oscars Winners Actors..."
                    self.classicalsActors = classicalActorsSaved.values().first!
                    self.collectionViewClassicals.reloadData()
                    self.getOscarsWinnerActorBy(id: self.oscarsWinnersIds[self.customIndex])
                    return
                }
            default: break
            }
        }
    }
    
    //MARK: - GET Oscars winners Actor By
    private func getOscarsWinnerActorBy(id: Int){
        
        let backgroundTaskIdentifier =
            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.async {
            self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
        }
        
        let container = try! Container()
        
        let OscarsWinnersActorsSaved = container.values(
            OscarsWinnersActors.self,
            matching: .all
        )
        
        if OscarsWinnersActorsSaved.count > 0 {
            var isContained = false
            for actor in OscarsWinnersActorsSaved.values().first!.actors!{
                if actor.id == id{
                    isContained = true
                }
            }
            if isContained{
                if self.customIndex < (self.oscarsWinnersIds.count - 1){
                    self.customIndex += 1
                    self.getOscarsWinnerActorBy(id: self.oscarsWinnersIds[self.customIndex])
                } else {
                    DispatchQueue.main.async {
                        self.progressIndicator?.progress = (Float(self.customIndex)/Float(self.mostPopularIds.count))
                        self.customIndex = 0
                        self.oscarsWinnersActors = OscarsWinnersActorsSaved.values().first!
                        self.progressIndicator?.hide(animated: true)
                        self.collectionViewTopCartoons.reloadData()
                    }
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                return
            }
        }
        
        GeneralManager.getActorDetails(actorID: id) { (response) in
            switch response {
            case .success(let actorResponse):
                var oscarsWinnerActors = OscarsWinnersActors.init(actors: [actorResponse])
                
                if OscarsWinnersActorsSaved.count > 0 {
                    oscarsWinnerActors = OscarsWinnersActorsSaved.values().first!
                    var isContained = false
                    for actor in oscarsWinnerActors.actors!{
                        if actor.id == actorResponse.id{
                            isContained = true
                        }
                    }
                    
                    if !isContained{
                        oscarsWinnerActors.actors?.append(actorResponse)
                    }
                    
                }
                
                try! container.write { transaction in
                    transaction.add(oscarsWinnerActors, update: .modified)
                }
                
                if self.customIndex < (self.oscarsWinnersIds.count - 1){
                    self.customIndex += 1
                    self.getOscarsWinnerActorBy(id: self.oscarsWinnersIds[self.customIndex])
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                } else {
                    self.progressIndicator?.progress = 1
                    self.customIndex = 0
                    self.progressIndicator?.label.text = "Loading Classical Actors..."
                    self.oscarsWinnersActors = OscarsWinnersActorsSaved.values().first!
                    self.progressIndicator?.hide(animated: true)
                    self.collectionViewTopCartoons.reloadData()
                    return
                }
            default: break
            }
        }
    }
    
    private func getActorsFromSearch(_ search: String){
        GeneralManager.getActorsFromSearch(query: search) { (response) in
            
            switch response{
            case .success(let actors):
                self.searchedActorsResults = actors
            case .empty:
                self.searchedActorsResults = nil
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
            self.getActorsFromSearch(searchText)
        }
    }
    
}

extension AllActorsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case self.collectionViewSearchOptions:
            return self.searchedActorsResults?.count ?? 0
        case self.collectionViewMostPopular:
            return self.mostPopularActors.actors?.count ?? 0
        case self.collectionViewRecentlyAdded:
            return self.marvelHeroesActor.actors?.count ?? 0
        case self.collectionViewClassicals:
            return self.classicalsActors.actors?.count ?? 0
        case self.collectionViewTopCartoons:
            return self.oscarsWinnersActors.actors?.count ?? 0
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! GeneralCustomCollectionViewCell
        let actorDetailsViewController = UIStoryboard.ActorDetails().instantiateViewController(withIdentifier: "ActorsDetailsViewController") as! ActorsDetailsViewController
        
        var actorID = 0
        if collectionView == self.collectionViewSearchOptions{
            actorID = currentCell.currentCellActor?.actor?.id ?? 0
        } else {
            actorID = currentCell.currentActor?.id ?? 0
        }
        
        self.view.showLoading()
        GeneralManager.getActorDetails(actorID: actorID) { (response) in
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
        
        var cellIdentifier = self.mainCellIdentifier
        
        if collectionView == self.collectionViewSearchOptions{
            cellIdentifier = self.searchCellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GeneralCustomCollectionViewCell
        
        
        switch collectionView{
        case self.collectionViewSearchOptions:
            cell.fillActorCellInfo(self.searchedActorsResults![indexPath.row], true)
        case self.collectionViewMostPopular:
            cell.fillActorMainCellInfo(self.mostPopularActors.actors![indexPath.row])
        case self.collectionViewRecentlyAdded:
            cell.fillActorMainCellInfo(self.marvelHeroesActor.actors![indexPath.row])
        case self.collectionViewClassicals:
            cell.fillActorMainCellInfo(self.classicalsActors.actors![indexPath.row])
        case self.collectionViewTopCartoons:
            cell.fillActorMainCellInfo(self.oscarsWinnersActors.actors![indexPath.row])
        default:
            break
        }
        
        return cell
    }
}
