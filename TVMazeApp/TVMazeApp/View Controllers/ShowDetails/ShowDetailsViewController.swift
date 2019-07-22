//
//  ShowDetailsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/15/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage

class ShowDetailsViewController: BaseViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDaysAir: UILabel!
    @IBOutlet weak var labelSummaryTitle: UILabel!
    @IBOutlet weak var labelSummaryBody: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    @IBOutlet weak var tableViewEpisodes: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewShowDetails: UIScrollView!
    
    let mainCellIdentifier = "mainEpisodeCell"
    let detailCellIdentifier = "detailEpisodeCell"
    
    var showDetails: ShowBean!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buttonFavorite.layer.cornerRadius = self.buttonFavorite.frame.size.height / 2
        self.buttonFavorite.layer.masksToBounds = true
        self.tableViewHeightConstraint.constant = self.tableViewEpisodes.contentSize.height
    }
    
    private func setupUI(){
        let container = try! Container()
        
        let favoritesSaved = container.values(
            Favorites.self,
            matching: .all
        )
        
        self.buttonFavorite.setImage(#imageLiteral(resourceName: "ic_btn_fav_deselected"), for: .normal)
        
        if favoritesSaved.count <= 0{
            
        } else {
            for show in favoritesSaved.values().first!.shows!{
                if show.id == showDetails.id{
                    self.buttonFavorite.setImage(#imageLiteral(resourceName: "ic_btn_fav_selected"), for: .normal)
                }
            }
        }
        
        self.setupCustomBackButton()
        if let showImage = self.showDetails.image{
            self.imageViewPoster.af_setImage(withURL: URL(string: showImage.medium!)!)
        } else {
            self.imageViewPoster.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewPoster.contentMode = .scaleAspectFit
        }
        
        let daysArray = self.showDetails.schedule!.days
        let days = daysArray!.joined(separator: ", ")
        self.labelDaysAir.text = days + " at " + (self.showDetails.schedule!.time ?? "??")
        
        let genresArray = self.showDetails.genres ?? ["none"]
        let genres = genresArray.joined(separator: ", ")
        self.labelGenres.text = "Genres: " + genres
        
        self.labelName.text = self.showDetails.name
        self.labelSummaryBody.text = self.showDetails.summary ?? ""
        
    }
    
    @IBAction func buttonFavTap(_ sender: UIButton) {
        
        let container = try! Container()
        
        let favoritesSaved = container.values(
            Favorites.self,
            matching: .all
        )
        
        if self.buttonFavorite.image(for: .normal) == #imageLiteral(resourceName: "ic_btn_fav_deselected"){
            self.buttonFavorite.setImage(#imageLiteral(resourceName: "ic_btn_fav_selected"), for: .normal)
            
            if favoritesSaved.count <= 0{
                let favorites = Favorites.init(actors: nil, shows: [self.showDetails])
                
                try! container.write { transaction in
                    transaction.add(favorites, update: .modified)
                }
                
            } else {
                var favorites = favoritesSaved.values().first!
                favorites.shows?.append(self.showDetails)
                
                try! container.write { transaction in
                    transaction.add(favorites, update: .modified)
                }
            }
            
        } else {
            
            self.buttonFavorite.setImage(#imageLiteral(resourceName: "ic_btn_fav_deselected"), for: .normal)
            
            var favorites = favoritesSaved.values().first!
            var index = 0
            
            for showFav in favorites.shows!{
                if showFav.id == showDetails.id{
                    favorites.shows?.remove(at: index)
                }
                index += 1
            }
            
            try! container.write { transaction in
                transaction.add(favorites, update: .modified)
            }
        }
    }
}

extension ShowDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.showDetails.episodes!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.showDetails.episodes![indexPath.section].isShowed == -1{
            self.showDetails.episodes![indexPath.section].isShowed = 0
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        } else {
            self.showDetails.episodes![indexPath.section].isShowed = -1
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showDetails.episodes![section].isShowed == -1{
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.mainCellIdentifier) as! EpisodeMainTableViewCell
            let currentEpisode = self.showDetails.episodes![indexPath.section]
            let completeName = (currentEpisode.name ?? "") + (". Season\(currentEpisode.season ?? 1) Episode \(currentEpisode.number ?? 1)")
            cell.labelTitle.text = completeName
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.detailCellIdentifier) as! EpisodeDetailTableViewCell
            
            if let episodeImage = self.showDetails.episodes![indexPath.section].image{
                cell.imageViewPoster.af_setImage(withURL: URL(string: episodeImage.medium!)!)
            } else {
                cell.imageViewPoster.image = #imageLiteral(resourceName: "AppIconImage")
                cell.imageViewPoster.contentMode = .scaleAspectFit
            }
            
            cell.labelSummary.text = self.showDetails.episodes![indexPath.section].summary
            
            return cell
        }
    }
}

class EpisodeMainTableViewCell: UITableViewCell{
    @IBOutlet weak var labelTitle: UILabel!
}

class EpisodeDetailTableViewCell: UITableViewCell{
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelSummary: UILabel!
}
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
