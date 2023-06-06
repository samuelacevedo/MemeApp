//
//  HomeViewController.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import UIKit
import SkeletonView
import Kingfisher

class HomeViewController: UIViewController {
    @IBOutlet var configButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    //MARK: View Model
    var viewModel: HomeViewModel?
    
    //MARK: Posts
    var postsList: [Post] = []
    var dynamicPostsList: [Post] = []
    
    private let cellIdentifier: String = "PostCell"
    
    //MARK: - View Did Layout Subviews
    override func viewDidLayoutSubviews() {
        
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: View Model
        viewModel = HomeViewModel()
        
        //MARK: Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        //MARK: Register Cell
        let cell = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: cellIdentifier)
        
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        viewModel?.load(Post.all)
        viewModel?.posts.bind { (respons) in
            if let posts = respons {
                self.postsList = posts
                self.dynamicPostsList = posts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else {
                
            }
        }
    }
    
}

//MARK: - TableView
extension HomeViewController: UITableViewDelegate, SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicPostsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        
        if dynamicPostsList.indices.contains(indexPath.item) {
            let element = dynamicPostsList[indexPath.item]
            
            cell.titleLabel.text = element.title
            cell.scoreValue.text = String(element.score)
            cell.commentValue.text = String(element.commentCount)
            
            if let urlUnwrapped = element.url {
                print(urlUnwrapped)
                
                let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
                cell.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                activityIndicator.center = cell.postImage.center
                
                cell.postImage.kf.setImage(with: urlUnwrapped, completionHandler: { _ in
                    activityIndicator.removeFromSuperview()
                })
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
