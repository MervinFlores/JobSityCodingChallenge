//
//  Show.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/15/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct ShowsSearchedBeans: Argo.Decodable {
    let shows: [ShowSearchedBean]?
    
    static func decode(_ json: JSON) -> Decoded<ShowsSearchedBeans> {
        return ShowsSearchedBeans.init <^> Array<ShowSearchedBean>.decode(json)
    }
}

struct ShowSearchedBean: Argo.Decodable {
    var score: Float?
    var show: ShowBean?
    
    static func decode(_ json: JSON) -> Decoded<ShowSearchedBean> {
        let schedule = curry(ShowSearchedBean.init)
        return schedule
            <^> json <|? "score"
            <*> json <|? "show"
    }
}

struct ShowBean {
    var id: Int?
    var url: String?
    var name: String?
    var type: String?
    var language: String?
    var status: String?
    var runtime: Int?
    var premiered: String?
    var officialSite: String?
    var weight: Int?
    var summary: String?
    var updated: Int?
    var genres: [String]?
    var schedule: Schedule?
    var rating: Rating?
    var network: Network?
    var webChannel: Network?
    var externals: ExternalBean?
    var image: UrlImagesInfo?
    var episodes: [Episode]?
}


extension ShowBean: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<ShowBean> {
        let id: Decoded<Int?> = json <|? "id"
        let runtime: Decoded<Int?> = json <|? "runtime"
        let weight: Decoded<Int?> = json <|? "weight"
        let updated: Decoded<Int?> = json <|? "updated"
        let genres: Decoded<[String]?> = json <||? "genres"
        let episodes: Decoded<[Episode]?> = json <||? ["_embedded", "episodes"]
        let show = curry(ShowBean.init)
            return show
            <^> id
            <*> json <|? "url"
            <*> json <|? "name"
            <*> json <|? "type"
            <*> json <|? "language"
            <*> json <|? "status"
            <*> runtime
            <*> json <|? "premiered"
            <*> json <|? "officialSite"
            <*> weight
            <*> json <|? "summary"
            <*> updated
            <*> genres
            <*> json <|? "schedule"
            <*> json <|? "rating"
            <*> json <|? "network"
            <*> json <|? "webChannel"
            <*> json <|? "externals"
            <*> json <|? "image"
            <*> episodes
    }
}

struct Schedule: Argo.Decodable {
    var time: String?
    var days: [String]?
    
    static func decode(_ json: JSON) -> Decoded<Schedule> {
        let schedule = curry(Schedule.init)
        return schedule
            <^> json <|? "time"
            <*> json <||? "days"
    }
}

struct Rating: Argo.Decodable  {
    var average: Float?
    
    static func decode(_ json: JSON) -> Decoded<Rating> {
        return Rating.init <^> json <|? "average"
    }
}

struct Network: Argo.Decodable  {
    var id: Int?
    var name: String?
    var country: Country?
    
    static func decode(_ json: JSON) -> Decoded<Network> {
        let schedule = curry(Network.init)
        return schedule
            <^> json <|? "id"
            <*> json <|? "name"
            <*> json <|? "country"
    }
}

struct ExternalBean: Argo.Decodable  {
    var tvrage: Int?
    var thetvdb: Int?
    var imdb: String?
    
    static func decode(_ json: JSON) -> Decoded<ExternalBean> {
        let externalBean = curry(ExternalBean.init)
        return externalBean
            <^> json <|? "tvrage"
            <*> json <|? "thetvdb"
            <*> json <|? "imdb"
    }
    
}

extension Episode: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Episode> {
        let episode = curry(Episode.init)
        return episode
            <^> json <|? "id"
            <*> json <|? "url"
            <*> json <|? "name"
            <*> json <|? "season"
            <*> json <|? "number"
            <*> json <|? "airdate"
            <*> json <|?  "airtime"
            <*> json <|? "airstamp"
            <*> json <|? "runtime"
            <*> json <|? "image"
            <*> json <|? "summary"
            <*> json <|? "runtime"
        
    }
}

struct Episode {
    var id: Int?
    var url: String?
    var name: String?
    var season: Int?
    var number: Int?
    var airdate: String?
    var airtime: String?
    var airstamp: String?
    var runtime: Int?
    var image: UrlImagesInfo?
    var summary: String?
    var isShowed: Int?
}

