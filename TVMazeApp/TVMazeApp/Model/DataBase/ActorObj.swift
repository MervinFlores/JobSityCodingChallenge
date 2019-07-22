//
//  ActorDAO.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/21/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class ActorObject: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    @objc dynamic var name = ""
    @objc dynamic var country: CountryObject?
    @objc dynamic var birthday = ""
    @objc dynamic var deathday = ""
    @objc dynamic var gender = ""
    @objc dynamic var image: UrlImagesInfoObject?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Actor: Persistable {
    
    public init(managedObject: ActorObject) {
        
        self.id = managedObject.id
        self.url = managedObject.url
        self.name = managedObject.name
        self.country = managedObject.country.flatMap(Country.init(managedObject:))
        self.birthday = managedObject.birthday
        self.deathday = managedObject.deathday
        self.gender = managedObject.gender
        self.image = managedObject.image.flatMap(UrlImagesInfo.init(managedObject:))
        
    }
    
    
    public func managedObject() ->  ActorObject {
        
        let actorObj = ActorObject()
        
        actorObj.id = self.id ?? 0
        actorObj.url = self.url ?? ""
        actorObj.name = self.name ?? ""
        actorObj.country = self.country?.managedObject()
        actorObj.birthday = self.birthday ?? ""
        actorObj.deathday = self.deathday ?? ""
        actorObj.gender = self.gender ?? ""
        actorObj.image = self.image?.managedObject()
        
        return actorObj
    }
}

extension Actor {
    
    public enum Query: QueryType {
        
        case id(Int)
        
        public var predicate: NSPredicate? {
            switch
            self {
            case .id(let value):
                return NSPredicate(format: "id == %@", value)
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "name")]
        }
    }
    
    public enum PropertyValue: PropertyValueType {
        
        case id(Int)
        
        public var propertyValuePair: PropertyValuePair {
            
            switch self {
                
            case .id(let id):
                return ("id", id)
            }
        }
    }
}
