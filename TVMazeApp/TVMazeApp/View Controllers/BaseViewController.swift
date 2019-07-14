//
//  BaseViewController.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import SideMenu
import UIKit

class BaseViewController: UIViewController {
    
    //PASAR ESTO A PRIVADO EN EL METODO SI NO SE USA MAS
    var logoImageView   : UIImageView!
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    
    var searchBarDelegate: SearchBarDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Funtions
    
    private func setCenterNavBarLogo(){

        let imageView = UIImageView(image: #imageLiteral(resourceName: "AppIconImage"))
        self.navigationItem.titleView = imageView
    }
    
    private func setRightItemTitle(title: String) {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.navigationController!.navigationBar.bounds.width*0.3, height: self.navigationController!.navigationBar.bounds.height))
        let customLabel = UILabel(frame: CGRect(x: self.navigationController!.navigationBar.bounds.width*(-0.03), y: 4, width: customView.layer.bounds.width, height: customView.layer.bounds.height))
        customLabel.text = title
        customLabel.lineBreakMode = .byWordWrapping
        customLabel.numberOfLines = 0
        customLabel.textAlignment = .right
        customLabel.textColor = UIColor.white
        customLabel.font = UIFont(name: "Aller-Regular", size: 13.0 - self.sizeFont())
        customView.addSubview(customLabel)
        
        let rightBarButton = UIBarButtonItem(customView: customView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setTitleView(_ title: String){
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.navigationController!.navigationBar.bounds.width*0.3, height: self.navigationController!.navigationBar.bounds.height))
        let customLabel = UILabel(frame: CGRect(x: self.navigationController!.navigationBar.bounds.width*(-0.03), y: 0, width: customView.layer.bounds.width, height: customView.layer.bounds.height))
        customLabel.text = title
        customLabel.lineBreakMode = .byWordWrapping
        customLabel.numberOfLines = 0
        customLabel.textAlignment = .right
        customLabel.textColor = UIColor.white
        customLabel.font = UIFont(name: "Aller-Regular", size: 15.0 - self.sizeFont())
        customView.addSubview(customLabel)
        
        self.navigationItem.titleView = customView
    }
    
    private func sizeFont() -> CGFloat{
        if UIScreen.main.scale == 2.0 {
            return 1
        } else {
            return 0
        }
    }
    
    private func sizeRightButtonWidht() -> CGFloat {
        if UIScreen.main.scale == 2.0 {
            return 108
        } else {
            return 115
        }
    }
    
    // MARK: - Navigation Bar Funtions
    
    func withoutMenuNavBar(title: String){
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.setCenterNavBarLogo()
        self.setRightItemTitle(title: title)
        
    }
    
    
    
    
    
    
    //MARK: - ZONA DE TRABAJO
    
    func regularNavBar(title: String, isSearchAvailable: Bool){
        
        self.setleftMenuButton()
        self.setupSideMenu()
        self.instantiateSideMenuController()
        self.navigationItem.title = title
        
        if isSearchAvailable{
            self.setupNewCustomSearchButton(false)
            self.searchBar.delegate = self
            self.searchBar.searchBarStyle = UISearchBar.Style.minimal
            
            let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = .white
        }
        
    }
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        let buttonSearch = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        if buttonSearch.tag == -1{
            self.hideSearchBar()
        } else {
            self.showSearchBar()
        }
    }
    
    private func setupNewCustomSearchButton(_ isSearchShowed: Bool){
        let customButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 45.0, height: 45.0))
        
        if isSearchShowed{
            customButton.setTitle("Cancel", for: .normal)
            customButton.addTarget(self, action: #selector(self.searchButtonPressed(sender:)), for: .touchUpInside)
            customButton.tag = -1
        } else {
            let searchImage = #imageLiteral(resourceName: "ic_search").withRenderingMode(.alwaysTemplate)
            customButton.setImage(searchImage, for: .normal)
            customButton.tintColor = .white
            customButton.imageEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
            customButton.addTarget(self, action: #selector(self.searchButtonPressed(sender:)), for: .touchUpInside)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: customButton)
        
        
    }
    
    func showSearchBar() {
        self.setupNewCustomSearchButton(true)
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        self.setupNewCustomSearchButton(false)
        navigationItem.titleView = nil
//        logoImageView.alpha = 0
//        UIView.animate(withDuration: 0.3, animations: {
//            self.navigationItem.titleView = self.logoImageView
//            self.logoImageView.alpha = 1
//        }, completion: { finished in
//
//        })
    }
    
    
    
    
    //MARK: -
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func withBackButtonNavBar(title: String){
        
        self.navigationController?.navigationBar.topItem?.title = " "
        self.setCenterNavBarLogo()
        self.setRightItemTitle(title: title)
        
    }
    
    func setleftMenuButton(){
        
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "ic_burguerMenu").withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.tintColor = .white
        menuButton.imageEdgeInsets = UIEdgeInsets.init(top: 7.0, left: 0.0, bottom: 7.0, right: 0.0)
        menuButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        menuButton.addTarget(self, action: #selector(self.showSideMenu(sender:)), for: .touchUpInside)
        
        let barMenuButton = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem = barMenuButton
    }
    
    // MARK: - set up popOverMenu
    
//    func setupPopOverMenu(){
//        let config = FTConfiguration.shared
//        config.backgoundTintColor = UIColor.white
//        config.menuSeparatorColor = UIColor.clear
//        config.menuRowHeight = self.view.layer.bounds.height * 0.05
//        config.menuWidth = self.view.layer.bounds.width * 0.25
//        config.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//
//    }
    
    // MARK: - MenuSide Methods
    
    func instantiateSideMenuController() {
        
        
        let sideMenu = UIStoryboard.Main().instantiateViewController(withIdentifier: "SideMenu")
        let tableViewController = sideMenu.children.first as? SideMenuTableViewController
        tableViewController?.delegate = self
        
        SideMenuManager.default.menuRightNavigationController = sideMenu as? UISideMenuNavigationController
    }
    
    
    func setupSideMenu() {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainNavBar = mainStoryboard.instantiateViewController(withIdentifier: "menuSide") as! SideMenuTableViewController
        mainNavBar.delegate = self
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: mainNavBar)
        menuLeftNavigationController.leftSide = true
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false

        
    }
    
    @objc func showSideMenu(sender: UIButton!) {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}

extension BaseViewController: SideMenuCustomDelegate {
    func logoButtonTouched() {
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var mainNavBar = mainStoryboard.instantiateViewController(withIdentifier: "loginNavBar") as! UINavigationController
//
//        if SQSessionManager.shareManager.getCurrentToken() != nil{
//            mainNavBar = mainStoryboard.instantiateViewController(withIdentifier: "HomeNavBar") as! UINavigationController
//        }
//        self.present(mainNavBar, animated: false, completion: nil)
    }
    
    func appearView(_ view: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 1.0
        })
    }
    
    func disappearView(_ view: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0.0
        })
    }
    private func showLoginAfterLogout(){
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let mainNavBar = mainStoryboard.instantiateViewController(withIdentifier: "loginNavBar") as! UINavigationController
//        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginForm") as! SQLogInViewController
//        let signUpViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginHome") as! SQSingUpViewController
//        mainNavBar.viewControllers = [signUpViewController, loginViewController]
//        self.present(mainNavBar, animated: true, completion: nil)
    }
    
    func logoutTouched() {
        
//        if let currentToken = SQSessionManager.shareManager.getCurrentToken(){
//            SQProgress.show(view: self.navigationController!.view)
//            SQAPI.shared.logOut(currentToken, completion: {(success, error) in
//                if success{
//                    SQProgress.hide(view: self.navigationController!.view)
//
//
//
//                } else {
//                    SQProgress.hide(view: self.navigationController!.view)
//                    self.errorLogoutAlert(error!)
//                }
//                SQSessionManager.shareManager.logout()
//                self.showLoginAfterLogout()
//            })
//        }
    }
    
    private func errorLogoutAlert(_ error: String){
//        self.showLoginAfterLogout()
//        let alertController = UIAlertController(title: "alertViewMsg_Error".localized, message: error, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "alertViewMsg_Accept".localized, style: UIAlertActionStyle.default) {
//            UIAlertAction in
//        }
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
    }
}

protocol SearchBarDelegate{
    func textToSearch(_ searchText: String)
}

extension BaseViewController: UISearchBarDelegate{
    //MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarDelegate.textToSearch(searchText)
    }
}
