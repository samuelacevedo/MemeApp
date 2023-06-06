//
//  Post.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import Foundation

struct Post {
    var title: String
    var urlAsString: String
    var url: URL?
    var score: Int
    var commentCount: Int
    
    init(){
        title = ""
        urlAsString = ""
        url = nil
        score = -1
        commentCount = -1
    }
}

extension Post {
    static var all: Resource<[Post]> = {
        guard let url = URL(string: "https://www.reddit.com/r/chile/new/.json?limit=100") else {
            fatalError("URL is incorrect")
        }
        
        return Resource<[Post]>(url: url)
    }()
    
    static func pagination(after: String) -> Resource<[Post]> {
        guard let url = URL(string: "https://www.reddit.com/r/chile/new/.json?limit=100&after=\(after)") else {
            fatalError("URL is incorrect")
        }
        
        return Resource<[Post]>(url: url)
    }

}
