//
//  SideMenuTableViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import SideMenu

protocol SideMenuCustomDelegate {
    func logoButtonTouched()
    func logoutTouched()
}

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet var menuTableView: UITableView!
    var delegate: SideMenuCustomDelegate!
    
    var isLogged: Bool!
    
    let cellIdentifier = "menuCell"
    
    //segues
    let goToAllShows = "goToAllShows"
    
    var optionNames = ["All Shows"]
    
    var optionImages: [UIImage] = [#imageLiteral(resourceName: "ic_allShows")]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
//        if SQSessionManager.shareManager.getCurrentToken() != nil{
//            self.isLogged = true
//        } else {
//            self.isLogged = false
//        }
        
        self.configNavBar()
        
        guard tableView.backgroundView == nil else {
            return
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark: - Private Functions
    
    func configNavBar(){
        let buttonLogo = UIButton.init(type: .custom)
        buttonLogo.setImage(#imageLiteral(resourceName: "ic_burguerMenu").withRenderingMode(.alwaysTemplate), for: .normal)
        buttonLogo.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        buttonLogo.imageEdgeInsets = UIEdgeInsets.init(top: 7.0, left: 0.0, bottom: 7.0, right: 0.0)
        buttonLogo.tintColor = .white
        buttonLogo.addTarget(self, action: #selector(self.logoButtonTouched(sender:)), for: .touchUpInside)
        
        let barButtonLogo = UIBarButtonItem.init(customView: buttonLogo)
        self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem = barButtonLogo
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.231372549, green: 0.5568627451, blue: 0.537254902, alpha: 1)
        
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        if !isLogged{
//            self.performSegue(withIdentifier: self.showMyShipment, sender: nil)
//
//        } else {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: self.goToAllShows, sender: nil)
//            case 6:
//                self.logout()
            default:
                break

            }
//        }
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! SideMenuCellTableViewCell
        
        cell.fillCell(self.optionNames[indexPath.row], self.optionImages[indexPath.row])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    // Mark: - LogOut
    
    private func logout(){
        
    }
    
    
    
    // Mark: - Button Actions
    
    @objc func logoButtonTouched(sender: UIButton!) {
        self.delegate.logoButtonTouched()
    }
}

class SideMenuCellTableViewCell: UITableViewCell{
    
    @IBOutlet var labelOption: UILabel!
    @IBOutlet var imageViewImage: UIImageView!
    
    func fillCell(_ optionName: String, _ optionImage: UIImage){
        self.labelOption.text = optionName
        self.imageViewImage.image = optionImage.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = .white
    }
}
