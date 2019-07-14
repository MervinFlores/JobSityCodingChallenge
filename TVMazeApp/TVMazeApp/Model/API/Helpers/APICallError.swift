//
//  APICallError.swift
//  TVMazeApp
//
//  Created by Mervin Flores on 7/14/19.
//  Copyright © 2019 Mervin Flores. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

typealias APICallErrorCallback = (APICallErrorImpl, String) -> Void

extension APICallError.Body: Argo.Decodable {
    static func decode(_ json: JSON) -> Argo.Decoded<APICallError.Body> {
        if let errJSON: JSON = Argo.decodedJSON(json, forKey: "error").value {
            debugPrint(errJSON)
            let err = curry(APICallError.Body.init)
            let tmp = err
                <^> errJSON <|? "title"
                <*> errJSON <|? "message"
            return tmp
                <*> errJSON <|? "type"
                <*> errJSON <|? "code"
                <*> errJSON <|? "subcode"
        }
        return .fromOptional(nil)
    }
}

protocol APICallErrorImpl: Error {
    func kind() -> APICallError.Kind
}

struct ErrorTitleDescription {
    var title: String
    var description: String
}

struct APICallError {
    
    static func getError(_ codeError: String) -> ErrorTitleDescription{
        switch codeError{
        default:
            return ErrorTitleDescription(title: "Connection Error", description: "Connection Error")
        }
    }
    
    enum Kind {
        case network
        case serialization
        case decoding
        case unexpected
        case http
    }
    
    struct Body {
        let title:   String?
        let message: String?
        let type:    String?
        let code:    Int?
        let subcode: Int?
    }
    
    class Simple: APICallErrorImpl {
        private let err:  Error
        
        init(_ err: Error) {
            self.err = err
        }
        
        func unwrap() -> Error {
            return err
        }
        
        func kind() -> APICallError.Kind {
            assert(false, "api call errors subclasses of error, must override its kind method")
            return self.err as! APICallError.Kind
        }
        
    }
    
    class Network: Simple {
        enum Reason: Int {
            case timedOut
            case connectionLost
            case notConnectedToInternet
        }
        
        let reason: Reason
        
        init(_ err: Error, reason: Reason) {
            self.reason = reason
            super.init(err)
        }
        
        override func kind() -> APICallError.Kind {
            return .network
        }
    }
    
    class Serialization: Simple {
        override func kind() -> APICallError.Kind {
            return .serialization
        }
    }
    
    class Decoding: Simple {
        override func kind() -> APICallError.Kind {
            return .decoding
        }
    }
    
    class Unexpected: Simple {
        override func kind() -> APICallError.Kind {
            return .unexpected
        }
    }
    
    class Http: APICallErrorImpl {
        let statusCode: Int
        let body:       Body?
        
        init(statusCode: Int, body: Body?) {
            self.statusCode = statusCode
            self.body = body
        }
        
        func hasBody() -> Bool {
            return body != nil
        }
        
        func kind() -> APICallError.Kind {
            return .http
        }
    }
    
    class Server:     Http{}
    class Conflict:   Http{}
    class BadRequest: Http{}
    class Forbidden:  Http{}
    class NotFound:   Http{}
    
    class Unauthorized: Http {
        enum Reason: Int {
            case bannedUser       = 702
            case tokenExpired     = 703
            case invalidToken     = 704
            case fatalForceLogout = 705
            case unknown          = -1
        }
        
        let reason: Reason
        
        override init(statusCode: Int, body: Body?) {
            if let bodyVal = body {
                debugPrint("unauthorized \(bodyVal)")
                if let code = bodyVal.code, let r = Reason(rawValue: code) {
                    self.reason = r
                } else {
                    self.reason = .unknown
                }
            } else {
                self.reason = .unknown
            }
            super.init(statusCode: statusCode, body: body)
        }
    }
    
}


