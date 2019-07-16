//
//  APIConst.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation

import UIKit
public class APIConst {
    
    static var baseURL: String {
        return "http://api.tvmaze.com"
    }
    
    struct MediaTypes {
        static let APPLICATION_JSON = "application/json"
        static let IMAGE_JPEG       = "image/jpeg"
    }
    
    //Maybe declare other routes
    
    struct HttpHeaders {
        
        static let ACCEPT = "Accept"
        
        static let CONTENT_TYPE = "Content-Type"
        
        static let ACCEPT_LANGUAGE = "Accept-Language"
        
        static let CONTENT_LANGUAGE = "Content-Language"
        
        static let CUSTOM_USER_AGENT = "X-Device-User-Agent"
        
        static let AUTHORIZATION = "Authorization"
        
        static let DISPLAY_DENSITY = "X-Device-Display-Density"
        
        static let ETAG_REQUEST = "If-None-Match"
        
        static let ETAG_RESPONSE = "Etag"
    }
    
    static let deviceDensityHeaderValue = "\(Int(160 * UIScreen.main.scale))"
    
    static let customUserAgentHeaderValue = UserAgentInfo.userAgentHeader
}

struct UserAgentInfo {
    
    static var displayName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    
    static var versionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static var systemVersion = UIDevice.current.systemVersion
    
    static let preferredLanguage = Locale.preferredLanguages[0]
    
    static let modelName = UIDevice.current.modelName
    
    static let udid = (UIDevice.current.identifierForVendor!.uuidString).lowercased()
    
    private static let screenSize = UIScreen.main.bounds
    
    static let screenWidth = "\(screenSize.width)"
    static let screenHeight = "\(screenSize.height)"
    
    static var userAgentHeader: String {
        let collection: [String] = [displayName, "/", versionNumber, " (iOS ", systemVersion, ";", preferredLanguage, ";", modelName, ";", udid, ")[screen params: ", screenWidth, "w x ", screenHeight, "h;", deviceDensityType, " ", APIConst.deviceDensityHeaderValue, "dpi]"]
        return collection.joined()
    }
    
    static var deviceDensityType: String {
        
        switch UIScreen.main.scale {
        case 1.0:
            return "mdpi"
        case 2.0:
            return "xhdpi"
        case 3.0:
            return "xxhdpi"
        default:
            // Should never happen, but returning most common dpi value in iOS doesn't seem like a bad idea
            return "xhdpi"
        }
    }
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

