//
//  HomeServices.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import Foundation
import SwiftyJSON

//MARK: - Http Method
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

//MARK: Network Error
enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    
    case none
}


class HomeServices: NSObject {
    func getPosts<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethos.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                
                return
            }
            
            if let responseAsString = String(data: data, encoding: .utf8) {
                let jsonresp = JSON.init(parseJSON: responseAsString)
                
                if jsonresp["data"]["children"].exists(), let childrenAsString = jsonresp["data"]["children"].rawString() {
                    let childrenAsJSON = JSON.init(parseJSON: childrenAsString)
                    var post: Post = Post()
                    if let childrens = childrenAsJSON.array {
                        var listOfPosts : [Post] = []
                        for child in childrens {
                            if child["data"]["title"].exists() {
                                print(child["data"]["title"].rawString()!)
                            }
                        }
                    }
                }
            }
                    
            /*if jsonresp.count == 0 {
                OperationQueue.main.addOperation {
                    completion(nil, "Ha ocurrido un error")
                }
                return
            }
            
            switch jsonresp["R"] {
            case "0":
                DispatchQueue.main.async {
                    do {*/
            
            /*
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                print(result)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }else {
                completion(.failure(.domainError))
            }*/
            
        }.resume()
    }
}
