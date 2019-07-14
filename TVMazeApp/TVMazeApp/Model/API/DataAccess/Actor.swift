//
//  Actor.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Actor{
        var id: Int?
        var url: String?
        var name: String?
        var country: Country?
        var birthday: String?
        var deathday: String?
        var gender: String?
        var image: UrlImagesInfo?
        var links: GenericalLinks?

}

struct Country{
    var name: String?
    var code: String?
    var timezone: String?
}

struct UrlImagesInfo{
    var medium: String?
    var original: String?
}

struct GenericalLinks {
    var link: String?

//    {
//        "self": {
//            "href": "http://api.tvmaze.com/people/70077"
//        }
//    }
    
}

extension Actor: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Actor> {
        let actor = curry(Actor.init)
        return actor
            <^> json <|? "id"
            <*> json <|? "url"
            <*> json <|? "name"
            <*> json <|? "country"
            <*> json <|? "birthday"
            <*> json <|? "deathday"
            <*> json <|? "gender"
            <*> json <|? "image"
            <*> json <|? "_links"
    }
}

extension Country: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Country> {
        let country = curry(Country.init)
        return country
            <^> json <|? "name"
            <*> json <|? "code"
            <*> json <|? "timezone"
    }
}
1
//{
//    "id": 70077,
//    "url": "http://www.tvmaze.com/people/70077/leonardo-dicaprio",
//    "name": "Leonardo DiCaprio",
//    "country": {
//        "name": "United States",
//        "code": "US",
//        "timezone": "America/New_York"
//    },
//    "birthday": "1974-11-11",
//    "deathday": null,
//    "gender": "Male",
//    "image": {
//        "medium": "http://static.tvmaze.com/uploads/images/medium_portrait/45/114667.jpg",
//        "original": "http://static.tvmaze.com/uploads/images/original_untouched/45/114667.jpg"
//    },
//    "_links": {
//        "self": {
//            "href": "http://api.tvmaze.com/people/70077"
//        }
//    }
//}
