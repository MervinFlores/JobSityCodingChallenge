//
//  FavoritesObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoritesObject: Object {
    @objc dynamic var id = ""
    
    let actors = List<ActorObject>()
    let shows = List<ShowBeanObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Favorites: Persistable {
    public init(managedObject: FavoritesObject) {
        self.actors = managedObject.actors.map({ (actor) -> Actor in return Actor.init(managedObject: actor)})
        self.shows = managedObject.shows.map({ (show) -> ShowBean in return ShowBean.init(managedObject: show)})
        
    }
    
    public func managedObject() -> FavoritesObject {
        let favoritesObj = FavoritesObject()
        
        if self.actors != nil {
            for actor in actors! {
                let q = actor
                favoritesObj.actors.append(q.managedObject())
            }
        }
        
        if self.shows != nil {
            for show in shows! {
                let q = show
                favoritesObj.shows.append(q.managedObject())
            }
        }
        
        favoritesObj.id = ""
        return favoritesObj
    }
}

extension Favorites {
    public enum Query: QueryType {
        
        case all
        
        public var predicate: NSPredicate? {
            switch
            self {
            case .all:
                return nil
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor]()
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

struct Favorites {
    var actors: [Actor]?
    var shows: [ShowBean]?
}
