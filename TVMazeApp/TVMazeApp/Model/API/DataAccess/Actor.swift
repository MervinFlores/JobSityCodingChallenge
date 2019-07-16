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

struct ActorSearchArray: Argo.Decodable {
    let array: [ActorSearchBean]?
    
    static func decode(_ json: JSON) -> Decoded<ActorSearchArray> {
        return ActorSearchArray.init <^> Array<ActorSearchBean>.decode(json)
    }
}

struct ActorSearchBean {
    var score: Float?
    var actor: Actor?
}

struct Actor{
    var id: Int?
    var url: String?
    var name: String?
    var country: Country?
    var birthday: String?
    var deathday: String?
    var gender: String?
    var image: UrlImagesInfo?
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

extension ActorSearchBean: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<ActorSearchBean> {
        let actorSearchBean = curry(ActorSearchBean.init)
        return actorSearchBean
            <^> json <|? "score"
            <*> json <|? "person"
    }
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

extension UrlImagesInfo: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<UrlImagesInfo> {
        let urlImagesInfo = curry(UrlImagesInfo.init)
        return urlImagesInfo
            <^> json <|? "medium"
            <*> json <|? "original"
    }
}
