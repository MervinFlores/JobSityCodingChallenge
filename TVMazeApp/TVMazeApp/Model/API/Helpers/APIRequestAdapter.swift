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
//import FacebookCore
//import FBSDKLoginKit
//import RealmSwift

class APIRequestAdapter: RequestAdapter {
    
    init() {}
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        // As long as token is set, send Auth header
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(APIConst.baseURL) {
            
            if urlRequest.allHTTPHeaderFields?[APIConst.HttpHeaders.AUTHORIZATION] == nil {
//                let authToken = AppSettings.tokenUtils.getBearerToken() ?? ""
                if Thread.isMainThread {
                    //                    authToken = SessionManager.getActiveSession()?.tokenPair?.bearer
                } else { //TODO: find a better way to handle this (temp fix due to UploadRequests
                    DispatchQueue.main.sync() {
                        //                        authToken = SessionManager.getActiveSession()?.tokenPair?.bearer
                    }
                }
//                let accessToken = authToken  //un IF al inicio
//                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: APIConst.HttpHeaders.AUTHORIZATION)
                //                    urlRequest.setValue(accessToken.asHttpHeaderVal(), forHTTPHeaderField: APIConst.HttpHeaders.AUTHORIZATION)
                
            }
            //            var etag: ETag?
            //            if Thread.isMainThread {
            //                etag = APIClient.etagManager().findETag(forURL: urlString)
            //            } else { //TODO: find a better way to handle this (temp fix due to UploadRequests
            //                DispatchQueue.main.sync() {
            //                    etag = APIClient.etagManager().findETag(forURL: urlString)
            //                }
            //            }
            //            if let tag = etag {
            //                urlRequest.setValue(tag.value, forHTTPHeaderField: APIConst.HttpHeaders.ETAG_REQUEST)
            //            }
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
            
            //            guard isTokenRenewalAllowed(unauthorizedErr) else {
            //                guard !isBannedUser(unauthorizedErr) else {
            //                    debugPrint("RequestRetrier called: banned user")
            //                    try! onBannedUser()
            //                    completion(false, 0.0)
            //                    NotificationCenter.default.post(name: NSNotification.bannedUser, object: nil)
            //                    return
            //                }
            //                debugPrint("token renewal not allowed, neither banned user")
            //                completion(false, 0.0)
            //                UserManager.logout(callAPILogoutService: false, callback: { (res) in
            //                    switch res{
            //                    case .ok, .error:
            //                        NotificationCenter.default.post(name: NSNotification.forcedLogout, object: nil)
            //                    }
            //                })
            //
            //                return
            //            }
            debugPrint("RequestRetrier called: token renewal")
            requestsToRetry.append(RequestToRetry(taskID: request.task!.taskIdentifier, requestRetryCompletion: completion))
            
            //            if(!isRefreshing) {
            //                refreshTokens { [weak self] succeeded in
            //                    guard let strongSelf = self else { return }
            //
            //                    strongSelf.lock.lock(); defer { strongSelf.lock.unlock() }
            //
            //                    strongSelf.requestsToRetry.sorted().forEach { $0.requestRetryCompletion(succeeded, 0.0) }
            //                    strongSelf.requestsToRetry.removeAll()
            //                }
            //            }
        } else {
            completion(false, 0.0)
        }
    }
    
    //    func onBannedUser() throws {
    //        let userID = SessionManager.getActiveSession()!.userID
    //        let realm = try! Realm()
    //        try SessionManager.endAllActiveSessions()
    //
    //        if AppSettings.Accounts.Authentication.isLinked(
    //            userID: userID,
    //            method: .facebook) && (FBSDKAccessToken.current() != nil){
    //            FBSDKLoginManager().logOut()
    //        }
    //
    //        try! realm.write {
    //            realm.deleteAll()
    //        }
    //
    //        AppSettings.ManageSettings.cleanAllUserDefaults()
    //    }
    
    
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
    
    //    private func refreshTokens(completion: @escaping RefreshCompletion) {
    //        guard !isRefreshing else { return }
    //        isRefreshing = true
    //
    //        UserManager.refreshAuthTokens(
    //            onSuccess: { [weak self] _ in
    //                guard let strongSelf = self else { return }
    //                completion(true)
    //                strongSelf.isRefreshing = false
    //            },
    //            onError: { [weak self] err in
    //                guard let strongSelf = self else { return }
    //                debugPrint("refreshTokens: failed, reason is \(err)")
    //                completion(false)
    //                strongSelf.isRefreshing = false
    //                NotificationCenter.default.post(name: NSNotification.forcedLogout, object: nil)
    //            }
    //        )
    //
    //
    //
    //    }
}

