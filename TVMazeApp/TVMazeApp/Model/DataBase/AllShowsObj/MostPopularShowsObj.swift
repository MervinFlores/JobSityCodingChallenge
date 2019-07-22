//
//  MostPopularShowsObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class MostPopularShowsObject: Object {
    @objc dynamic var id = ""
    
    let shows = List<ShowBeanObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}

extension MostPopularShows: Persistable {
    public init(managedObject: MostPopularShowsObject) {
        self.shows = managedObject.shows.map({ (show) -> ShowBean in return ShowBean.init(managedObject: show)})
        
    }
    
    public func managedObject() ->  MostPopularShowsObject {
        let mostPopularShowsObj = MostPopularShowsObject()
        
        if self.shows != nil {
            for show in shows! {
                let q = show
                mostPopularShowsObj.shows.append(q.managedObject())
            }
        }
        
        mostPopularShowsObj.id = ""
        return mostPopularShowsObj
    }
}

extension MostPopularShows {
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

struct MostPopularShows {
    var shows: [ShowBean]?
}
