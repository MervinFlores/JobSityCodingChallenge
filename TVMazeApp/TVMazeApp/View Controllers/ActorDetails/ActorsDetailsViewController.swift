//
//  ActorsDetailsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/15/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage

class ActorsDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imageViewActorImage: UIImageView!
    @IBOutlet weak var labelActorName: UILabel!
    @IBOutlet weak var labelDates: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    
    var currentActor: Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buttonFavorite.layer.cornerRadius = self.buttonFavorite.frame.size.height / 2
        self.buttonFavorite.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCustomBackButton()
        self.setupUI()
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
            for actor in favoritesSaved.values().first!.actors!{
                if actor.id == currentActor.id{
                    self.buttonFavorite.setImage(#imageLiteral(resourceName: "ic_btn_fav_selected"), for: .normal)
                }
            }
        }
        
        if let imageActor = self.currentActor.image{
            self.imageViewActorImage.af_setImage(withURL: URL(string: imageActor.medium!)!)
        } else {
            self.imageViewActorImage.image = #imageLiteral(resourceName: "AppIconImage")
            self.imageViewActorImage.contentMode = .scaleAspectFit
        }
        
        self.labelActorName.text = self.currentActor.name
        
        var actorDates = self.currentActor.birthday
        
        if self.currentActor.birthday != nil{
            if let deathDay = self.currentActor.deathday{
                actorDates = actorDates! + " - " + deathDay
            }
        } else {
            actorDates = ""
        }
        
        self.labelDates.text = actorDates
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
                let favorites = Favorites.init(actors: [self.currentActor], shows: nil)
                
                try! container.write { transaction in
                    transaction.add(favorites, update: .modified)
                }
                
            } else {
                var favorites = favoritesSaved.values().first!
                favorites.actors?.append(self.currentActor)
                
                try! container.write { transaction in
                    transaction.add(favorites, update: .modified)
                }
            }
            
        } else {
            
            self.buttonFavorite.setImage(#imageLiteral(resourceName: "ic_btn_fav_deselected"), for: .normal)
            
            var favorites = favoritesSaved.values().first!
            var index = 0
            
            for actorFav in favorites.actors!{
                if actorFav.id == currentActor.id{
                    favorites.actors?.remove(at: index)
                }
                index += 1
            }
            try! container.write { transaction in
                transaction.add(favorites, update: .modified)
            }
        }
    }
}


