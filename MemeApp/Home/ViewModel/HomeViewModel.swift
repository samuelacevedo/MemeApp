//
//  HomeViewModel.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import Foundation

//MARK: - Protocol
protocol ObservableHomeProtocol {
    //MARK: Functions
    func load(_ resource: Resource<[Post]>)
    
    //MARK: Observables
    var posts: Observable<([Post]?, String?)> { get set }
}

class HomeViewModel: NSObject, ObservableHomeProtocol {
    var posts: Observable<([Post]?, String?)>
    
    //MARK: Service Object
    var service: HomeServices?
    
    override init(){ 
        service = HomeServices()
        posts = Observable((nil, nil))
    }
    
    //MARK: Load
    func load(_ resource: Resource<[Post]>) {
        service?.load(resource: resource, completion: { (result, after) in
            switch result {
                case .success(let posts):
                    if posts.count > 0 {
                        self.posts.value = (posts, after)
                    }else {
                        self.posts.value = (nil, after)
                    }
                case .failure(_):
                    self.posts.value = (nil, after)
            }
        })
    }
    
    
}
