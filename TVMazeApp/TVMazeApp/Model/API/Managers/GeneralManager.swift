//
//  GeneralManager.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation

class GeneralManager {
    
    //MARK: - Searchin Actors
    enum getActorsFromSearchCallback {
        case success([ActorSearchBean])
        case empty
        case error
    }
    
    typealias getActorsFromSearchCallbacks = (getActorsFromSearchCallback) -> Void
    
    static func getActorsFromSearch(query: String, callback: @escaping getActorsFromSearchCallbacks){
        APIClient.executeRequest(req: APIClient.request(GeneralRouter.searchForActors(query: query)), onSuccess: { (res: ActorSearchArray?, _) in
            if let response = res {
                if let actors = response.array{
                    if actors.isEmpty{
                        callback(.empty)
                    } else {
                        callback(.success(actors))
                    }
                } else {
                    callback(.error)
                }
            } else {
                callback(.error)
            }
        }) { (error, _) in
            callback(.error)
        }
    }
    
    //MARK: - Searchin Actors
    enum getShowFromSearchCallback {
        case success([ShowSearchedBean])
        case empty
        case error
    }
    
    typealias getShowsFromSearchCallbacks = (getShowFromSearchCallback) -> Void
    
    static func getShowsFromSearch(query: String, callback: @escaping getShowsFromSearchCallbacks){
        APIClient.executeRequest(req: APIClient.request(GeneralRouter.searchForShow(query: query)), onSuccess: { (res: ShowsSearchedBeans?, _) in
            if let response = res{
                if let shows = response.shows{
                    if shows.isEmpty{
                        callback(.error)
                    } else {
                        callback(.success(shows))
                    }
                } else {
                    callback(.error)
                }
            } else {
                callback(.error)
            }
        }) { (error, _) in
            callback(.error)
        }
    }
    
    //MARK: - Get Show Details and Episodes
    
    enum getShowDetailsCallback {
        case success(ShowBean)
        case empty
        case error
    }
    
    typealias getShowDetailsCallbacks = (getShowDetailsCallback) -> Void
    
    static func getShowDetails(showID: Int, callback: @escaping getShowDetailsCallbacks){
        APIClient.executeRequest(req: APIClient.request(GeneralRouter.getShow(showID: showID)), onSuccess: { (res: ShowBean?, _) in
            if let response = res{
                callback(.success(response))
            } else {
                callback(.error)
            }
        }) { (error, _) in
            callback(.error)
        }
    }
    
    //MARK: - Get Actor Details
    
    enum getActorCallback {
        case success(Actor)
        case empty
        case error
    }
    
    typealias getActorCallbacks = (getActorCallback) -> Void
    
    static func getActorDetails(actorID: Int, callback: @escaping getActorCallbacks){
        
        APIClient.executeRequest(req: APIClient.request(GeneralRouter.getActor(actorID: actorID)), onSuccess: { (res: Actor?, _) in
            if let response = res{
                callback(.success(response))
            } else {
                callback(.error)
            }
        }) { (error, _) in
            callback(.error)
        }
    }
}
