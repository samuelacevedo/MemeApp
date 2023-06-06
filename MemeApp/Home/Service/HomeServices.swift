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
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
                    if let childrens = childrenAsJSON.array {
                        var listOfPosts : [Post] = []
                        for child in childrens {
                            var post: Post = Post()
                            //MARK: Title
                            if child["data"]["title"].exists() {
                                post.title = child["data"]["title"].rawString()!
                            }
                            //MARK: URL
                            if child["data"]["url"].exists() {
                                post.urlAsString = child["data"]["url"].rawString()!
                                if let url = URL(string: post.urlAsString) {
                                    post.url = url
                                }
                            }
                            //MARK: Score
                            if child["data"]["score"].exists() {
                                if let score = child["data"]["score"].int {
                                    post.score = score
                                }
                            }
                            //MARK: Comments
                            if child["data"]["num_comments"].exists() {
                                if let comments = child["data"]["num_comments"].int {
                                    post.commentCount = comments
                                }
                            }
                            
                            listOfPosts.append(post)
                        }
                        
                        //MARK: Completion
                        if let posts : T = listOfPosts as? T { completion(.success(posts)) }
                        else { completion(.failure(.decodingError)) }

                    }
                }
            }
        }.resume()
    }
}
