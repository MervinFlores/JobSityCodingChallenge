//
//  TopCartoonsObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/22/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

final class TopCartoonsShowsObject: Object {
    @objc dynamic var id = ""
    
    let shows = List<ShowBeanObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension TopCartoonsShow: Persistable {
    public init(managedObject: TopCartoonsShowsObject) {
        self.shows = managedObject.shows.map({ (show) -> ShowBean in return ShowBean.init(managedObject: show)})
        
    }
    
    public func managedObject() ->  TopCartoonsShowsObject {
        let TopCartoonsShowsObj = TopCartoonsShowsObject()
        
        if self.shows != nil {
            for show in shows! {
                let q = show
                TopCartoonsShowsObj.shows.append(q.managedObject())
            }
        }
        
        TopCartoonsShowsObj.id = ""
        return TopCartoonsShowsObj
    }
}

extension TopCartoonsShow {
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

struct TopCartoonsShow {
    var shows: [ShowBean]?
}
