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

public class APIService {
    
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
