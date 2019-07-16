//
//  APIRequestAdapter.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Alamofire
import Foundation
import Argo

class APIRequestAdapter: RequestAdapter {
    
    init() {}
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(APIConst.baseURL) {
            if urlRequest.allHTTPHeaderFields?[APIConst.HttpHeaders.AUTHORIZATION] == nil {
                if Thread.isMainThread {
                } else {
                    DispatchQueue.main.sync() {
                    }
                }
            }
        }
        return urlRequest
    }
}


fileprivate struct RequestToRetry {
    let taskID: Int
    let requestRetryCompletion: RequestRetryCompletion
}

extension RequestToRetry: Comparable {
    static func < (lhs: RequestToRetry, rhs: RequestToRetry) -> Bool {
        return lhs.taskID < rhs.taskID
    }
    
    static func == (lhs: RequestToRetry, rhs: RequestToRetry) -> Bool {
        return lhs.taskID == rhs.taskID
    }
}


class APIRequestRetrier: RequestRetrier {
    
    private typealias RefreshCompletion = (_ succeeded: Bool) -> Void
    
    private let lock         = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestToRetry] = []
    
    func should(_ manager: Alamofire.SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock(); defer{ lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401 && !request.request!.url!.path.hasPrefix("RegisterRouter.LOGIN_PATH_PREFIX"){
            let unauthorizedErr = getUnauthorizedError(request)
            
            
            debugPrint("RequestRetrier called: token renewal")
            requestsToRetry.append(RequestToRetry(taskID: request.task!.taskIdentifier, requestRetryCompletion: completion))
            
            
        } else {
            completion(false, 0.0)
        }
    }
    
    
    
    func getUnauthorizedError(_ request: Request) -> APICallError.Unauthorized? {
        guard let data = request.delegate.data else {
            return nil
        }
        let response = request.task!.response! as! HTTPURLResponse
        let jsonSerializationResult = DataRequest.jsonResponseSerializer().serializeResponse(nil, response, data, nil)
        guard case let .success(responseJSON) = jsonSerializationResult else {
            return nil
        }
        guard let errorBody = APICallError.Body.decode(JSON(responseJSON)).value else {
            return nil
        }
        return APICallError.Unauthorized(statusCode: 401, body: errorBody)
    }
    
    func isBannedUser(_ err: APICallError.Unauthorized?) -> Bool {
        guard let unauthorizedErr = err else {
            return false
        }
        return unauthorizedErr.reason == .bannedUser
    }
    
    func isTokenRenewalAllowed(_ err: APICallError.Unauthorized?) -> Bool {
        guard let unauthorizedErr = err else {
            return false
        }
        return unauthorizedErr.reason == .tokenExpired
    }
}

