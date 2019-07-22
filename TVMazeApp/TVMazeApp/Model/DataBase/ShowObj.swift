//
//  ShowObj.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/21/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - ShowBeanObject
final class ShowBeanObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var language = ""
    @objc dynamic var status = ""
    @objc dynamic var runtime = 0
    @objc dynamic var premiered = ""
    @objc dynamic var officialSite = ""
    @objc dynamic var weight = 0
    @objc dynamic var summary = ""
    @objc dynamic var updated = 0
    @objc dynamic var schedule: ScheduleObject?
    @objc dynamic var rating: RatingObject?
    @objc dynamic var network: NetworkObject?
    @objc dynamic var webChannel: NetworkObject?
    @objc dynamic var externals: ExternalBeanObject?
    @objc dynamic var image: UrlImagesInfoObject?
    let genres = List<String>()
    let episodes = List<EpisodeObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ShowBean: Persistable {
    
    public init(managedObject: ShowBeanObject) {
        
        self.id = managedObject.id
        self.url = managedObject.url
        self.name = managedObject.name
        self.type = managedObject.type
        self.language = managedObject.language
        self.status = managedObject.status
        self.runtime = managedObject.runtime
        self.premiered = managedObject.premiered
        self.officialSite = managedObject.officialSite
        self.weight = managedObject.weight
        self.summary = managedObject.summary
        self.updated = managedObject.updated
        self.schedule = managedObject.schedule.flatMap(Schedule.init(managedObject:))
        self.rating = managedObject.rating.flatMap(Rating.init(managedObject:))
        self.network = managedObject.network.flatMap(Network.init(managedObject:))
        self.webChannel = managedObject.network.flatMap(Network.init(managedObject:))
        self.externals = managedObject.externals.flatMap(ExternalBean.init(managedObject:))
        self.image = managedObject.image.flatMap(UrlImagesInfo.init(managedObject:))
        self.episodes = managedObject.episodes.map({ (epi) -> Episode in return Episode.init(managedObject: epi)})
        
        let genres: [String] = managedObject.genres.map { (genres) -> String in return genres }
        
        if genres.count > 0 {
            self.genres = genres
        } else {
            self.genres = nil
        }
        
    }
    
    
    public func managedObject() ->  ShowBeanObject {
        
        let showBeanObj = ShowBeanObject()
        
        showBeanObj.id = self.id ?? 0
        showBeanObj.url = self.url ?? ""
        showBeanObj.name = self.name ?? ""
        showBeanObj.type = self.type ?? ""
        showBeanObj.language = self.language ?? ""
        showBeanObj.status = self.status ?? ""
        showBeanObj.runtime = self.runtime ?? 0
        showBeanObj.premiered = self.premiered ?? ""
        showBeanObj.officialSite = self.officialSite ?? ""
        showBeanObj.weight = self.weight ?? 0
        showBeanObj.summary = self.summary ?? ""
        showBeanObj.updated = self.updated ?? 0
        showBeanObj.schedule = self.schedule?.managedObject()
        showBeanObj.rating = self.rating?.managedObject()
        showBeanObj.network = self.network?.managedObject()
        showBeanObj.webChannel = self.network?.managedObject()
        showBeanObj.externals = self.externals?.managedObject()
        showBeanObj.image = self.image?.managedObject()
        
        if self.episodes != nil {
            for episode in episodes! {
                let q = episode
                showBeanObj.episodes.append(q.managedObject())
            }
        }
        
        return showBeanObj
    }
}

extension ShowBean{
    
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

// MARK: - EpisodeObject
final class EpisodeObject: Object{
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    @objc dynamic var name = ""
    @objc dynamic var season = 0
    @objc dynamic var number = 0
    @objc dynamic var airdate = ""
    @objc dynamic var airtime = ""
    @objc dynamic var airstamp = ""
    @objc dynamic var runtime = 0
    @objc dynamic var image: UrlImagesInfoObject?
    @objc dynamic var summary = ""
    @objc dynamic var isShowed = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Episode: Persistable {
    
    public init(managedObject: EpisodeObject) {
        
        self.id = managedObject.id
        self.url = managedObject.url
        self.name = managedObject.name
        self.season = managedObject.season
        self.number = managedObject.number
        self.airdate = managedObject.airdate
        self.airtime = managedObject.airtime
        self.airstamp = managedObject.airstamp
        self.runtime = managedObject.runtime
        self.image = managedObject.image.flatMap(UrlImagesInfo.init(managedObject:))
        self.summary = managedObject.summary
        self.isShowed = managedObject.isShowed
        
    }
    
    
    public func managedObject() -> EpisodeObject {
        let episodeObject = EpisodeObject()
        
        episodeObject.id = self.id ?? 0
        episodeObject.url = self.url ?? ""
        episodeObject.name = self.name ?? ""
        episodeObject.season = self.season ?? 0
        episodeObject.number = self.number ?? 0
        episodeObject.airdate = self.airdate ?? ""
        episodeObject.airtime = self.airtime ?? ""
        episodeObject.airstamp = self.airstamp ?? ""
        episodeObject.runtime = self.runtime ?? 0
        episodeObject.image = self.image?.managedObject()
        episodeObject.summary = self.summary ?? ""
        episodeObject.isShowed = self.isShowed ?? 0
        
        return episodeObject
    }
}

extension Episode{
    
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

// MARK: - ExternalBeanObject
final class ExternalBeanObject: Object {
    @objc dynamic var tvrage = 0
    @objc dynamic var thetvdb = 0
    @objc dynamic var imdb = ""
    
    override static func primaryKey() -> String? {
        return "tvrage"
    }
}

extension ExternalBean: Persistable {
    
    public init(managedObject: ExternalBeanObject) {
        self.tvrage = managedObject.tvrage
        self.thetvdb = managedObject.thetvdb
        self.imdb = managedObject.imdb
    }
    
    
    public func managedObject() -> ExternalBeanObject {
        
        let externalBeanObject = ExternalBeanObject()
        externalBeanObject.tvrage = self.tvrage ?? 0
        externalBeanObject.thetvdb = self.thetvdb ?? 0
        externalBeanObject.imdb = self.imdb ?? ""
        
        return externalBeanObject
    }
}

extension ExternalBean{
    
    public enum Query: QueryType {
        
        case tvrage(Int)
        
        public var predicate: NSPredicate? {
            switch
            self {
            case .tvrage(let value):
                return NSPredicate(format: "tvrage == %@", value)
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "name")]
        }
    }
    
    public enum PropertyValue: PropertyValueType {
        
        case tvrage(Int)
        
        public var propertyValuePair: PropertyValuePair {
            
            switch self {
                
            case .tvrage(let id):
                return ("tvrage", id)
            }
        }
    }
}

// MARK: - ScheduleObject
final class ScheduleObject: Object {
    @objc dynamic var time = ""
    let days = List<String>()
    
    override static func primaryKey() -> String? {
        return "time"
    }
}

extension Schedule: Persistable {
    
    public init(managedObject: ScheduleObject) {
        self.time = managedObject.time
        
        let days: [String] = managedObject.days.map { (day) -> String in
            return day
        }
        
        if days.count > 0 {
            self.days = days
        } else {
            self.days = nil
        }
    }
    
    
    public func managedObject() -> ScheduleObject {
        
        let scheduleObj = ScheduleObject()
        
        scheduleObj.time = self.time ?? ""
        
        if self.days != nil {
            for day in days! {
                let q = day
                scheduleObj.days.append(q)
            }
        }
        
        return scheduleObj
    }
}

extension Schedule{
    
    public enum Query: QueryType {
        
        case time(String)
        
        public var predicate: NSPredicate? {
            switch
            self {
            case .time(let value):
                return NSPredicate(format: "time == %@", value)
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "name")]
        }
    }
    
    public enum PropertyValue: PropertyValueType {
        
        case time(String)
        
        public var propertyValuePair: PropertyValuePair {
            
            switch self {
                
            case .time(let time):
                return ("time", time)
            }
        }
    }
}

// MARK: - RatingObject
final class RatingObject: Object {
    @objc dynamic var average = Float(0.0)
}

extension Rating: Persistable {
    
    public init(managedObject: RatingObject) {
        self.average = managedObject.average 
    }
    
    
    public func managedObject() -> RatingObject {
        
        let ratingObj = RatingObject()
        
        ratingObj.average = self.average ?? (Float(0))
        
        return ratingObj
    }
}

extension Rating{
    
    public enum Query: QueryType {
        
        case average(Float)
        
        public var predicate: NSPredicate? {
            switch
            self {
            case .average(let value):
                return NSPredicate(format: "average == %@", value)
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "name")]
        }
    }
    
    public enum PropertyValue: PropertyValueType {
        
        case average(Float)
        
        public var propertyValuePair: PropertyValuePair {
            
            switch self {
                
            case .average(let average):
                return ("average", average)
            }
        }
    }
}

// MARK: -  NetworkObject
final class NetworkObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var country: CountryObject?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Network: Persistable {
    
    public init(managedObject: NetworkObject) {
        self.id = managedObject.id
        self.name = managedObject.name
        self.country = managedObject.country.flatMap(Country.init(managedObject:))
    }
    
    
    public func managedObject() -> NetworkObject {
        
        let networkObj = NetworkObject()
        networkObj.id = self.id ?? 0
        networkObj.name = self.name ?? ""
        networkObj.country = self.country?.managedObject()
        
        return networkObj
    }
}

extension Network{
    
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
