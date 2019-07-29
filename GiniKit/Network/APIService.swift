//
//  APIService.swift
//  GiniKit
//
//  Created by Nitesh Tak on 24/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Foundation
import Alamofire

public typealias CompletionHandler = (Any?) -> ()

public protocol APIServiceProtocol {
    
    func getCats(with page: Int, parameters: [String: Any]?, completion: @escaping CompletionHandler)
    func addFovourite(with parameters: [String: Any], completion: @escaping CompletionHandler)
    func getFavorites(parameters: [String: Any]?, completion: @escaping CompletionHandler)
    func deleteFovourite(with favouriteId: Int, parameters: [String: Any]?, completion: @escaping CompletionHandler)
}

public class APIService: APIServiceProtocol {
    
    public static var shared: APIService {
        get {
            if _shared == nil {
                _shared = APIService()
            }
            return _shared!
        }
    }
    
    private static var _shared: APIService? = nil
    
    public class func set(shared: APIService) {
        _shared = shared
    }
    
    public func getCats(with page: Int, parameters: [String: Any]? = nil, completion: @escaping CompletionHandler) {
        
        guard let url = URL(string: APIRouter.cats(page).path) else { return }
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: APIRouter.header)
            .responseJSON { (response) in
                switch response.result {
                case .failure(_):
                    completion(nil)
                case .success(_):
                    guard let data = response.data else { return }
                    do {
                        let cats = try JSONDecoder().decode([Cat].self, from: data)
                        completion(cats)
                    } catch {
                        completion(nil)
                    }
                }
        }
    }
    
    public func addFovourite(with parameters: [String: Any], completion: @escaping CompletionHandler) {
        
        guard let url = URL(string: APIRouter.addFavourite.path) else { return }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: APIRouter.header)
            .responseJSON { (response) in
                
                switch response.result {
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    print(error)
                    
                case .success(let value):
                    completion(value)
                }
        }
    }
    
    public func getFavorites(parameters: [String: Any]? = nil, completion: @escaping CompletionHandler) {
        
        guard let url = URL(string: APIRouter.favourites.path) else { return }
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: APIRouter.header)
            .responseJSON { (response) in
                switch response.result {
                case .failure(_):
                    completion(nil)
                case .success(_):
                    guard let data = response.data else { return }
                    do {
                        let cats = try JSONDecoder().decode([Favorite].self, from: data)
                        completion(cats)
                    } catch {
                        completion(nil)
                    }
                }
        }
    }
    
    public func deleteFovourite(with favouriteId: Int, parameters: [String: Any]? = nil, completion: @escaping CompletionHandler) {
        
        guard let url = URL(string: APIRouter.deleteFavourite(favouriteId).path) else { return }
        
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: APIRouter.header)
            .responseJSON { (response) in
                
                switch response.result {
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    print(error)
                    
                case .success(let value):
                    completion(value)
                }
        }
    }
}


public class MockApiService: APIServiceProtocol {
    
    public init() { }
    
    public func getCats(with page: Int, parameters: [String : Any]?, completion: @escaping CompletionHandler) {
        isFetchCatsCalled = true
        completeClosure = { _ in }
    }
    
    public func addFovourite(with parameters: [String : Any], completion: @escaping CompletionHandler) {
        completion("Success")
    }
    
    public func getFavorites(parameters: [String : Any]?, completion: @escaping CompletionHandler) {
        completion([Favorite]())
    }
    
    public func deleteFovourite(with favouriteId: Int, parameters: [String : Any]?, completion: @escaping CompletionHandler) {
        completion("Success")
    }
    
    
    public var isFetchCatsCalled = false
    
    public var cats: [Cat] = [Cat]()
    
    var completeClosure: ((Any?) -> ())!
    
    public func fetchSuccess() {
        completeClosure(cats)
    }
    
    func fetchFail(error: Error?) {
        completeClosure(error?.localizedDescription)
    }
    
}
