//
//  Post.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import Foundation

struct Post {
    var title: String
    var url: String
    var score: Int
    var commentCount: Int
}

extension Post {
    static var all: Resource<[Post]> = {
        guard let url = URL(string: "https://www.reddit.com/r/chile/new/.json?limit=2") else {
            fatalError("URL is incorrect")
        }
        
        return Resource<[Post]>(url: url)
    }()
}
