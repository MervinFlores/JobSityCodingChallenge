//
//  ImagesUrlObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/21/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class UrlImagesInfoObject: Object {
    @objc dynamic var medium = ""
    @objc dynamic var original = ""
    
    override static func primaryKey() -> String? {
        return "medium"
    }
}

extension UrlImagesInfo: Persistable {
    public init(managedObject: UrlImagesInfoObject) {
        self.medium = managedObject.medium
        self.original = managedObject.original
    }
    
    public func managedObject() ->  UrlImagesInfoObject {
        let urlImagesInfoObj = UrlImagesInfoObject()
        urlImagesInfoObj.medium = self.medium ?? ""
        urlImagesInfoObj.original = self.original ?? ""
        
        return urlImagesInfoObj
    }
}

extension UrlImagesInfo {
    public enum Query: QueryType {
        
        case url(String)
        
        public var predicate: NSPredicate? {
            switch
            self {
            case .url(let value):
                return NSPredicate(format: "url == %@", value)
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "name")]
        }
    }
    
    public enum PropertyValue: PropertyValueType {
        case url(String)
        
        public var propertyValuePair: PropertyValuePair {
            
            switch self {
            case .url(let url):
                return ("url", url)
            }
        }
    }
}
