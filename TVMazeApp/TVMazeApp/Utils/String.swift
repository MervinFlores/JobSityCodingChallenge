//
//  String.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/13/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    mutating func replacePlaceholders(_ vals: [String: Any]) -> String{
        for (placeholderName, val) in vals {
            self = self.replacingOccurrences(of: "{{\(placeholderName)}}", with: val as! String)
        }
        return self
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
