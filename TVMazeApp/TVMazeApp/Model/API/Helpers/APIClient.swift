//
//  APIClient.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Alamofire
import Argo

class APIClient {
    
    private static let shared = APIClient()
    private static let REQUEST_TIMEOUT: TimeInterval = 30
    private static let responseProcessingQueue = DispatchQueue(label: "MervinFloresJobsityChallenge.TVMazeApp.response-queue", qos: .utility, attributes: [.concurrent])
    
    private let session: Alamofire.SessionManager
    
    init() {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders[APIConst.HttpHeaders.CONTENT_TYPE] = APIConst.MediaTypes.APPLICATION_JSON
        
        let configuration = Alamofire.URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = APIClient.REQUEST_TIMEOUT
        
        session =  Alamofire.SessionManager(configuration: configuration)
        session.adapter = APIRequestAdapter()
        session.retrier = APIRequestRetrier()
    }
    
    static func executeRequest<T: Argo.Decodable> (
        req:       DataRequest,
        onSuccess: DataRequest.DecodableCallback<T>? = nil,
        onError:   APICallErrorCallback?             = nil) where T == T.DecodedType {
        print("REQUEST", req.request?.url as Any)
        
        req.validate().responseAPISerializer(queue: responseProcessingQueue) {
            (res: Alamofire.DataResponse<T?>) in
            switch res.result {
            case .success:
                if let response = res.result.value {
                    DispatchQueue.main.async {
                        onSuccess?(response, (req.request!.url!.absoluteString, res.response!.findHeaderValue(APIConst.HttpHeaders.ETAG_RESPONSE)))
                    }
                } else {
                    DispatchQueue.main.async {
                        onSuccess?(nil, (req.request!.url!.absoluteString, nil))
                    }
                }
            case .failure:
                let err = res.result.error!
                switch err{
                case is APICallError.Network:
                    break
                case is APICallError.Server:
                    break
                case is APICallError.Serialization:
                    break
                default:
                    break
                }
                DispatchQueue.main.async {
                    onError?(res.result.error! as! APICallErrorImpl, req.request!.url!.absoluteString)
                }
            }
        }
    }
    
    static func executeRequest<T: Argo.Decodable> (
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = Alamofire.SessionManager.multipartFormDataEncodingMemoryThreshold,
        to: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        onSuccess: DataRequest.DecodableCallback<T>? = nil,
        onError:   APICallErrorCallback?             = nil) where T == T.DecodedType {
        
        var httpHeaders = (headers != nil) ? headers: HTTPHeaders()
        
        httpHeaders![APIConst.HttpHeaders.CONTENT_TYPE] = "multipart/form-data"
        
        shared.session.upload(multipartFormData: multipartFormData,
                              usingThreshold: UInt64.init(),
                              to: to,
                              method: method,
                              headers: httpHeaders,
                              encodingCompletion: { (encodingResult) in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.validate().responseAPISerializer(queue: responseProcessingQueue) {
                                        (response: Alamofire.DataResponse<T?>) in
                                        switch response.result {
                                        case .success:
                                            if let res = response.result.value {
                                                DispatchQueue.main.async {
                                                    onSuccess?(res, (upload.request!.url!.absoluteString, nil))
                                                }
                                            } else {
                                                DispatchQueue.main.async {
                                                    onSuccess?(nil, (upload.request!.url!.absoluteString, nil))
                                                }
                                            }
                                        case .failure:
                                            let err = response.result.error!
                                            switch err{
                                            case is APICallError.Network:
                                                break
                                            default:
                                                break
                                            }
                                            DispatchQueue.main.async {
                                                onError?(response.result.error! as! APICallErrorImpl, upload.request!.url!.absoluteString)
                                            }
                                        }
                                        
                                    }
                                case .failure(let encodingError):
                                    DispatchQueue.main.async {
                                        onError?(APICallError.Serialization(
                                            SimpleError.onlyDescr(description: "multipart encoding issue: \(encodingError)")),
                                                 "\(APIConst.baseURL)\(try! to.asURL().absoluteString)"
                                        )
                                    }
                                }
        }
        )
    }
    
    
    @discardableResult
    static func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        return shared.session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    @discardableResult
    static func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return shared.session.request(urlRequest)
    }
    
    
}

