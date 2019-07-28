//
//  APIRouter.swift
//  GiniKit
//
//  Created by Nitesh Tak on 24/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Alamofire

public enum APIRouter: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        //TO DO: create url request
        
        var urlComponents = URLComponents(string: path)!
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "3"),
            URLQueryItem(name: "order", value: "DESC"),
            URLQueryItem(name: "page", value: "1")
        ]

        let url = urlComponents.url!

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("55bd8605-9630-4933-b71e-0c27d00cedf4", forHTTPHeaderField: "x-api-key")
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
    
    case cats(Int)
    case favourites
    case addFavourite
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .cats, .favourites:
            return .get
        case .addFavourite:
            return .post
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .cats(let page):
            return "/images/search?limit=2&order=DESC&page=\(page)"
        case .favourites:
            return "/favourites?sub_id=nitesh-1234&limit=2&order=DESC&page=0"
        case .addFavourite:
            return "/favourites"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .cats:
            return nil
        case .favourites:
            return nil
        case .addFavourite:
            return nil
        }
    }
    
    static var header: [String: String] {
        return ["x-api-key": "55bd8605-9630-4933-b71e-0c27d00cedf4", "Content-Type": "application/json"]
    }
}


public struct CatApp {
    
    struct Domain {
        static let baseURL = "https://api.thecatapi.com/v1"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
    }
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

