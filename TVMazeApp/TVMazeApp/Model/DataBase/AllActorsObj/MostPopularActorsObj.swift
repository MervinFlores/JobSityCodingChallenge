//
//  MostPopularActorsObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class MostPopularActorsObject: Object {
    @objc dynamic var id = ""
    
    let actors = List<ActorObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension MostPopularActors: Persistable {
    public init(managedObject: MostPopularActorsObject) {
        self.actors = managedObject.actors.map({ (actor) -> Actor in return Actor.init(managedObject: actor)})
        
    }
    
    public func managedObject() ->  MostPopularActorsObject {
        let mostPopularActorsObj = MostPopularActorsObject()
        
        if self.actors != nil {
            for actor in actors! {
                let q = actor
                mostPopularActorsObj.actors.append(q.managedObject())
            }
        }
        
        mostPopularActorsObj.id = ""
        return mostPopularActorsObj
    }
}

extension MostPopularActors {
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

struct MostPopularActors {
    var actors: [Actor]?
}
