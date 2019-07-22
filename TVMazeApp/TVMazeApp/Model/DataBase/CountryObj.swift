//
//  CountryObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/21/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class CountryObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var code = ""
    @objc dynamic var timezone = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

extension Country: Persistable {
    
    public init(managedObject: CountryObject){
        self.name = managedObject.name
        self.code = managedObject.code
        self.timezone = managedObject.timezone
    }
    
    public func managedObject() -> CountryObject {
        let countryObj = CountryObject()
        countryObj.name = self.name ?? ""
        countryObj.code = self.code ?? ""
        countryObj.timezone = self.timezone ?? ""
        
        return countryObj
    }
    
}

extension Country {
    
    public enum Query: QueryType {
        
        case name(String)
        
        public var predicate: NSPredicate? {
            switch
            self {
                
            case .name(let value):
                return NSPredicate(format: "name == %@", value)
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            
            return [SortDescriptor(keyPath: "name")]
        }
    }
    
    public enum PropertyValue: PropertyValueType {
        case name(String)
        
        public var propertyValuePair: PropertyValuePair {
            
            switch self {
                
            case .name(let name):
                return ("name", name)
                
            }
        }
    }
}
