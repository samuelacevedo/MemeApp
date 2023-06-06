//
//  HomeViewModel.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import Foundation
import UIKit
import SkeletonView

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
                    self.posts.value = (posts, after)
                case .failure(_):
                    self.posts.value = (nil, after)
            }
        })
    }
    
    func clean() {
        self.posts.value = (nil, nil)
    }
    
    func setNoResultDescription(label: UILabel){
        label.text = "Sorry, there are no results for this search.\nPlease try anothe phrase."
    }
}

//MARK: - Skeleton Setup
extension HomeViewModel {
    func enableSkeleton(viewController: UIViewController) {
        if let home = viewController as? HomeViewController {
            home.tableView.isSkeletonable = true
        }
    }
    
    func showAnimation(viewController: UIViewController) {
        if let home = viewController as? HomeViewController {
            home.tableView.showAnimatedSkeleton()
        }
    }
    
    func disableSkeleton(viewController: UIViewController) {
        if let home = viewController as? HomeViewController {
            home.tableView.hideSkeleton()
        }
    }
}
