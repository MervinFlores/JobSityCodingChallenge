//
//  Colors.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/13/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

extension UIView{
    func showLoading(message:String = "") {
        if let controller = self.inputViewController{
            controller.navigationItem.rightBarButtonItem?.isEnabled = false
            controller.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        HUD.show(.progress, onView: self)
    }
    
    func showSuccessIndicator(message:String = "") {
        HUD.flash(.success, delay: 1.0)
    }
    
    func showErrorIndicator(){
        HUD.flash(.error, delay: 1.0)
    }
    
    func dissmissLoading (isSuccess:Bool = true){
        if let controller = self.inputViewController{
            controller.navigationItem.rightBarButtonItem?.isEnabled = true
            controller.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        HUD.hide()
    }
}

