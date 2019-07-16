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

}
