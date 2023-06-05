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
    func getPosts(_ resource: Resource<[Post]>)
    
    //MARK: Observables
    var posts: Observable<(Resource<[Post]>?)> { get set }
}

class HomeViewModel: NSObject, ObservableHomeProtocol {
    var posts: Observable<Resource<[Post]>?>
    
    //MARK: Service Object
    var service: HomeServices?
    
    override init(){
        service = HomeServices()
        posts = Observable(nil)
    }
    
    func getPosts(_ resource: Resource<[Post]>) {
        service?.getPosts(resource: resource, completion: { result in
            
        })
    }
    
    
}
