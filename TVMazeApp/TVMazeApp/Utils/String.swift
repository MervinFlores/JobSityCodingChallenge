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
    
//    func fromBase64() -> String? {
//        guard let data = Data(base64Encoded: self) else {
//            return nil
//        }
//        return String(data: data, encoding: .utf8)
//    }
//    
//    func toBase64() -> String {
//        return Data(self.utf8).base64EncodedString()
//    }
    
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
    
    //            ✓
    //        CHECK MARK
    //        Unicode: U+2713, UTF-8: E2 9C 93
//    static let checkmark = "\u{2713}"
    
    
    //            ×
    //        MULTIPLICATION SIGN
    //        Unicode: U+00D7, UTF-8: C3 97
//    static let crossmark = "\u{2715}"
    
//    func calculateHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
//        return ceil(boundingBox.height)
//    }
//    
//    func calculateWidth(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
//        return ceil(boundingBox.width)
//    }
}
