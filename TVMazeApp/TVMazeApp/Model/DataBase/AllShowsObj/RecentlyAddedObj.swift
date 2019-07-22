//
//  RecentlyAddedObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class RecentlyAddedShowsObject: Object {
    @objc dynamic var id = ""
    
    let shows = List<ShowBeanObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}

extension RecentlyAddedShows: Persistable {
    public init(managedObject: RecentlyAddedShowsObject) {
        self.shows = managedObject.shows.map({ (show) -> ShowBean in return ShowBean.init(managedObject: show)})
        
    }
    
    public func managedObject() ->  RecentlyAddedShowsObject {
        let RecentlyAddedShowsObj = RecentlyAddedShowsObject()
        
        if self.shows != nil {
            for show in shows! {
                let q = show
                RecentlyAddedShowsObj.shows.append(q.managedObject())
            }
        }
        
        RecentlyAddedShowsObj.id = ""
        return RecentlyAddedShowsObj
    }
}

extension RecentlyAddedShows {
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

struct RecentlyAddedShows {
    var shows: [ShowBean]?
}
