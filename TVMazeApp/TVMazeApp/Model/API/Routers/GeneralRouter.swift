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
    case getTwilioToken(accountID: Int)
    case getShow(showID: Int)
    case searchForShow(query: String)
    case searchForActors(query: String)
    
    var method: HTTPMethod {
        switch self {
        case .getTwilioToken:
            return .get
        case .getShow:
            return .get
        case .searchForShow:
            return .get
        case .searchForActors:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getTwilioToken(let accountID):
            return "/v3/accounts/\(accountID)/twilio/accessToken"
        case .getShow(let showID):
            return "/shows/\(showID)"
        case .searchForShow:
            return "/search/shows"
        case .searchForActors:
            return "/search/people"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIConst.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        //Add needed headers like in the example
        switch self {
        default:
            break
        }
        
        // If URL has params, add them here like the example
        switch self {
        case .getTwilioToken:
            let searchParams = ["target":"1"]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            print(urlRequest as Any)
            
        case .getShow:
            let searchParams = ["embed":"episodes"]
//            ?embed=episodes
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            print(urlRequest)
            
        case .searchForShow(let query):
            let searchParams = ["q":query]
//            /search/shows?q=:query
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            print(urlRequest)
            
        case .searchForActors(let query):
            let searchParams = ["q": query]
//             /search/people?q=:query
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
            print(urlRequest)
            
        default:
            break
        }
        
        return urlRequest
    }
    
}
