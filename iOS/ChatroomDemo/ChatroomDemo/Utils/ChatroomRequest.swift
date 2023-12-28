//
//  ChatroomRequest.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/30.
//

import UIKit
import ChatroomUIKit


public struct ChatroomRequestHTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = ChatroomRequestHTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = ChatroomRequestHTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = ChatroomRequestHTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = ChatroomRequestHTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = ChatroomRequestHTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = ChatroomRequestHTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = ChatroomRequestHTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = ChatroomRequestHTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = ChatroomRequestHTTPMethod(rawValue: "TRACE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

@objcMembers public class ChatroomRequest: NSObject, URLSessionDelegate {
    
    @objc public static var shared = ChatroomRequest()
    
    var host: String = <#您的服务器主机地址#>
    
    private lazy var config: URLSessionConfiguration = {
        //MARK: - session config
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return config
    }()
    
    private var session: URLSession?
    
    override init() {
        super.init()
        self.session = URLSession(configuration: self.config, delegate: self, delegateQueue: .main)
    }
    
    public func constructRequest(method: ChatroomRequestHTTPMethod,
                                 uri: String,
                                 params: Dictionary<String,Any>,
                                 headers:[String : String],
                                 callBack:@escaping ((Data?,HTTPURLResponse?,Error?) -> Void)) -> URLSessionTask? {
        let string = self.host+uri
        if let url = URL(string: string) {
            //MARK: - request
            var urlRequest = URLRequest(url: url)
            if method == .put || method == .post {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
                } catch {
                    assert(false, "\(error.localizedDescription)")
                }
            }
            urlRequest.allHTTPHeaderFields = headers
            urlRequest.httpMethod = method.rawValue
            let task = self.session?.dataTask(with: urlRequest){
                if $2 == nil {
                    let response = ($1 as? HTTPURLResponse)
                    if response?.statusCode ?? -1 != 200 {
                        consoleLogInfo("\(urlRequest.curlString)", type: .debug)
                    }
                    callBack($0,response,$2)
                } else {
                    callBack(nil,nil,$2)
                }
            }
            task?.resume()
            return task
        } else {
            return nil
        }
        
    }
    
    @objc public func sendRequest(method: String,
                                  uri: String,
                                  params: Dictionary<String,Any>,
                                  headers:[String : String],
                                  callBack:@escaping ((Data?,HTTPURLResponse?,Error?) -> Void)) -> URLSessionTask? {
        guard let url = URL(string: self.host+uri) else { return nil }
        //MARK: - request
        var urlRequest = URLRequest(url: url)
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            assert(false, "\(error.localizedDescription)")
        }
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method
        let task = self.session?.dataTask(with: urlRequest){
            if $2 == nil {
                callBack($0,($1 as? HTTPURLResponse),$2)
            } else {
                callBack(nil,nil,$2)
            }
        }
        task?.resume()
        return task
    }
    
    @objc public func configHost(url: String) {
        self.host = url
    }
    
    //MARK: - URLSessionDelegate
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential,credential)
        }
    }
    
}

extension URLRequest {
    var curlString: String {
        guard let url = url else { return "" }
        
        var curlString = "curl -v"
        
        if let method = httpMethod {
            curlString += " -X \(method)"
        }
        
        curlString += " '\(url.absoluteString)'"
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                curlString += " -H '\(key): \(value)'"
            }
        }
        
        if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            curlString += " -d '\(bodyString)'"
        }
        
        
        return curlString
    }
}
