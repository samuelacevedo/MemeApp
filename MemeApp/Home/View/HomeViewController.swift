//
//  HomeViewController.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var configButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    //MARK: View Model
    var viewModel: HomeViewModel?
    
    //MARK: - View Did Layout Subviews
    override func viewDidLayoutSubviews() {
        
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: View Model
        viewModel = HomeViewModel()
        
        viewModel?.getPosts(Post.all)
        //viewModel?.permissionResult.bind { (respond) in
            
        //}
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
