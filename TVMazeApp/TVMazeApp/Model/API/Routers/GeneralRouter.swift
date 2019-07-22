//
//  GeneralRouter.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Alamofire

enum GeneralRouter: URLRequestConvertible {
    case getShow(showID: Int)
    case getActor(actorID: Int)
    case searchForShow(query: String)
    case searchForActors(query: String)
    var method: HTTPMethod {
        switch self {
        case .getShow:
            return .get
        case .searchForShow:
            return .get
        case .searchForActors:
            return .get
        case .getActor(let actorID):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getShow(let showID):
            return "/shows/\(showID)"
        case .searchForShow:
            return "/search/shows"
        case .searchForActors:
            return "/search/people"
        case .getActor(let actorID):
            return "/people/\(actorID)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIConst.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        
        switch self {
        default:
            break
        }
        
        switch self {
        case .getShow:
            let searchParams = ["embed":"episodes"]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            
        case .searchForShow(let query):
            let searchParams = ["q":query]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            
        case .searchForActors(let query):
            let searchParams = ["q": query]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            
        default:
            break
        }
        
        return urlRequest
    }
    
}
