//
//  APIResponseHandler.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Alamofire
import Argo

enum SimpleError: Error{
    case onlyDescr(description: String)
}

struct APIResponseSerializer<T: Argo.Decodable>: Alamofire.DataResponseSerializerProtocol where T == T.DecodedType {
    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<T?> = { (request, response, data, error) in
        
        if let err = error, err is URLError {
            switch (err as! URLError).code {
            case .timedOut:
                return .failure(APICallError.Network(error!, reason: .timedOut))
            case .networkConnectionLost:
                return .failure(APICallError.Network(error!, reason: .connectionLost))
            case .notConnectedToInternet:
                return .failure(APICallError.Network(error!, reason: .notConnectedToInternet))
            default:
                break
            }
        }
        
        if data == nil || data!.count == 0 { //no body response
            if response != nil{
                switch response!.statusCode{
                case 200, 201, 202, 204:
                    return .success(nil)
                case 304:
                    debugPrint("etag match for call: \(request!.url!.absoluteString)")
                    return .success(nil)
                case 404:
                    debugPrint("not found with no body")
                    var errorBody: APICallError.Body? = nil
                    let err = APICallError.NotFound(statusCode: response!.statusCode, body: errorBody)
                    return .failure(err)
                default:
                    return .failure(APICallError.Unexpected(SimpleError.onlyDescr(description: "Unexpected API call empty response for a response which code !IN(201,202,204,304]; code is: \(response!.statusCode)")))
                }
            }
        }
        
        let jsonSerializationResult = DataRequest.jsonResponseSerializer().serializeResponse(request, response, data, nil)
        guard case let .success(responseJSON) = jsonSerializationResult else {
            debugPrint("API response jsonResponseSerializer, error: \(jsonSerializationResult.error!)")
            return .failure(APICallError.Serialization( jsonSerializationResult.error!))
        }
        
        
        let httpStatus = response!.statusCode
        guard (200 ... 299 ~= httpStatus) || (httpStatus == 304) else {
            var err: APICallErrorImpl
            var errorBody: APICallError.Body? = APICallError.Body.decode(JSON(responseJSON)).value
            switch httpStatus{
            case 500 ..< 600: //server errors
                err = APICallError.Server(statusCode: httpStatus, body: nil)
            case 404: //not found
                err = APICallError.NotFound(statusCode: httpStatus, body: errorBody)
            case 409: //conflict
                err = APICallError.Conflict(statusCode: httpStatus, body: errorBody)
            case 403: //forbidden
                err = APICallError.Forbidden(statusCode: httpStatus, body: errorBody)
            case 400, 406, 410, 411, 412, 415:
                err = APICallError.BadRequest(statusCode: httpStatus, body: errorBody)
            case 401:
                err = APICallError.Unauthorized(statusCode: httpStatus, body: errorBody)
            default:
                err = APICallError.Unexpected(
                    SimpleError.onlyDescr(description: "Uncaught http status error \(httpStatus)"))
            }
            debugPrint("API response serializer, http KO: \(err)\n statusCode: \(response!.statusCode) \n with http error: response: \(response!); responseJSON: \(responseJSON)")
            return .failure(err)
        }
        
        let decodedResponseValue = T.decode(JSON(responseJSON))
        guard case let .success(responseValue) = decodedResponseValue else {
            debugPrint("API response serializer, http OK, KO on decoding: \(decodedResponseValue.error!)")
            return .failure(APICallError.Decoding(decodedResponseValue.error!))
        }
        return .success(responseValue)
    }
}

extension Alamofire.DataRequest {
    
    typealias DecodableCallback<T: Argo.Decodable> = (T?, (String, String?)) -> Void
    
    public static func decodableSerializer<T: Argo.Decodable>() -> DataResponseSerializer<T?> where T == T.DecodedType {
        return Alamofire.DataResponseSerializer { request, response, data, error in
            return APIResponseSerializer<T>().serializeResponse(
                request,
                response,
                data,
                error
            )
        }
    }
    
    
    @discardableResult
    public func responseAPISerializer<T: Argo.Decodable>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<T?>) -> Void) -> Self where T == T.DecodedType {
        return response(
            queue: queue,
            responseSerializer: Alamofire.DataRequest.decodableSerializer(),
            completionHandler: completionHandler
        )
    }
}

extension HTTPURLResponse {
    func findHeaderValue(_ headerName: String) -> String? {
        let keyValues = allHeaderFields.map { (String(describing: $0.key).lowercased(), String(describing: $0.value)) }
        
        if let headerValue = keyValues.filter({ $0.0 == headerName.lowercased() }).first {
            return headerValue.1
        }
        return nil
    }
}

