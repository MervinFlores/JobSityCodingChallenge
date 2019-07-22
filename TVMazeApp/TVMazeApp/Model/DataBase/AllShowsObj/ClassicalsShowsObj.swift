//
//  ClassicalsShowsObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class ClassicalShowsObject: Object {
    @objc dynamic var id = ""
    
    let shows = List<ShowBeanObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}

extension ClassicalShows: Persistable {
    public init(managedObject: ClassicalShowsObject) {
        self.shows = managedObject.shows.map({ (show) -> ShowBean in return ShowBean.init(managedObject: show)})
        
    }
    
    public func managedObject() ->  ClassicalShowsObject {
        let ClassicalShowsObj = ClassicalShowsObject()
        
        if self.shows != nil {
            for show in shows! {
                let q = show
                ClassicalShowsObj.shows.append(q.managedObject())
            }
        }
        
        ClassicalShowsObj.id = ""
        return ClassicalShowsObj
    }
}

extension ClassicalShows {
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

struct ClassicalShows {
    var shows: [ShowBean]?
}
