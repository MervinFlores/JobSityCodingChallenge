//
//  GeneralManager.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation

class GeneralManager {
    
    //MARK: - GET TOKEN
    
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
                        callback(.success(actors))
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
}
//
//extension PaginatedResponseBean {
//    func isLastPage() -> Bool {
//        return links!.next == nil
//    }
//
//    func isFirstPage() -> Bool {
//        return links!.previous == nil
//    }
//}
//
//struct PaginatedResponseSingleListBean<T: Argo.Decodable>: PaginatedResponseBean where T.DecodedType == T {
//    let links:  PaginatedResponseLinks?
//    let meta:   PaginatedResponseMetadata?
//    let data:   [T]
//}
