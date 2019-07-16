//
//  StoryBoard.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/13/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    //Main
    static func Main () -> UIStoryboard {
        return UIStoryboard(name:"Main", bundle: Bundle.main)
    }
    
    //ShowDetails
    static func ShowDetails () -> UIStoryboard {
        return UIStoryboard(name:"ShowDetails", bundle: Bundle.main)
    }
    
    //ActorDetails
    static func ActorDetails () -> UIStoryboard {
        return UIStoryboard(name:"ActorDetails", bundle: Bundle.main)
    }
}
