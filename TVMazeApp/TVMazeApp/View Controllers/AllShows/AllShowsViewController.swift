//
//  AllShowsViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import UIKit
import AlamofireImage

class AllShowsViewController: BaseViewController {

    @IBOutlet weak var collectionViewMostPopular: UICollectionView!
    @IBOutlet weak var collectionViewRecentlyAdded: UICollectionView!
    @IBOutlet weak var collectionViewClassicals: UICollectionView!
    @IBOutlet weak var collectionViewTopCartoons: UICollectionView!
    
    @IBOutlet weak var labelMostPopular: UILabel!
    @IBOutlet weak var labelRecentlyAdded: UILabel!
    @IBOutlet weak var labelClassicals: UILabel!
    @IBOutlet weak var labelTopCartoons: UILabel!
    
    let cellIdentifier = "ShowsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
//        self.nameLabels()
        
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

extension AllShowsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! GeneralCustomCollectionViewCell
        
        cell.fillCell("Split", "https://images-na.ssl-images-amazon.com/images/I/41AK%2B6G1sNL._SY445_.jpg")
        
        return cell
    }
}

class GeneralCustomCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var imageViewItem: UIImageView!
    
    func fillCell(_ name: String, _ imageURL: String){
        self.imageViewItem.af_setImage(withURL: URL.init(string: imageURL)!)
    }
    
}
