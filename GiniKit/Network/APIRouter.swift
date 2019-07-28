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
    case deleteFavourite(Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .cats, .favourites:
            return .get
        case .addFavourite:
            return .post
        case .deleteFavourite:
            return .delete
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .cats(let page):
            return CatApp.Domain.baseURL + "/images/search?limit=20&order=DESC&page=\(page)"
        case .favourites:
            return CatApp.Domain.baseURL + "/favourites?sub_id=\(APIRouter.userId)&limit=30&order=DESC&page=0"
        case .addFavourite:
            return CatApp.Domain.baseURL + "/favourites"
        case .deleteFavourite(let favId):
            return CatApp.Domain.baseURL + "/favourites/\(favId)"
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
        case .deleteFavourite(_):
            return nil
        }
    }
    
    public static var userId: String {
        get {
            return "nitesh-1234"
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

