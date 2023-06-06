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
    
    //MARK: No Results
    @IBOutlet var noResultView: UIView!
    @IBOutlet var noResultDescription: UILabel!
    
    //MARK: View Model
    var viewModel: HomeViewModel?
    
    //MARK: Posts
    var postsList: [Post] = []
    var dynamicPostsList: [Post] = []
    var after: String?
    
    private let cellIdentifier: String = "PostCell"
    
    //MARK: Pull To Refresh
    var refreshControl: UIRefreshControl!
    
    var searchQueue: OperationQueue = OperationQueue()

    //MARK: - View Did Layout Subviews
    override func viewDidLayoutSubviews() {
        tableView.layoutSkeletonIfNeeded()
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
        
        //MARK: Pull To Refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        //MARK: Search Bar
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        //MARK: Set No Result Description
        viewModel?.setNoResultDescription(label: noResultDescription)
    }
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: Load Posts
        loadPosts()
    }
    
    //MARK: - Pull To Refresh
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    @objc func onRefresh() {
        run(after: 2) {
            self.refreshControl.endRefreshing()
            self.pagination(pull: true)
        }
    }
    
    //MARK: Skeleton
    func setupSkeleton(){
        self.viewModel?.enableSkeleton(viewController: self)
        self.viewModel?.showAnimation(viewController: self)
    }
    
    //MARK: - Load Posts
    private func loadPosts() {
        DispatchQueue.main.async {
            self.setupSkeleton()
        }
        
        viewModel?.load(Post.all)
        viewModel?.posts.bind { (posts, after) in
            //MARK: DisableSkeleton
            if let posts = posts {
                self.postsList = posts
                self.dynamicPostsList = posts
                self.after = after
                
                self.viewModel?.clean()
                
                DispatchQueue.main.async {
                    self.viewModel?.disableSkeleton(viewController: self)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Pagination
    private func pagination(pull: Bool = false ) {
        if let pagination = after {
            viewModel?.load(
                            Post.pagination(after: pagination)
                        )
            viewModel?.posts.bind { (posts, after) in
                if let posts = posts {
                    if pull {
                        self.postsList = []
                        self.dynamicPostsList = []
                    }
                    
                    self.postsList.append(contentsOf: posts)
                    self.dynamicPostsList = self.postsList
                    self.after = after
                    
                    self.viewModel?.clean()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Search Posts
    private func searchingPosts(searchText: String){
        DispatchQueue.main.async {
            self.noResultView.isHidden = true
            self.setupSkeleton()
        }
        
        viewModel?.load(
            Post.searchingPosts(byText: searchText)
        )
        viewModel?.posts.bind { (posts, after) in
            if let posts = posts {
                if posts.count > 0 {
                    self.dynamicPostsList = []
                    
                    self.dynamicPostsList = posts
                    
                    self.viewModel?.clean()
                    
                    DispatchQueue.main.async {
                        self.viewModel?.disableSkeleton(viewController: self)
                        self.noResultView.isHidden = true
                        self.tableView.reloadData()
                    }
                }else {
                    self.viewModel?.clean()
                    DispatchQueue.main.async {
                        self.viewModel?.disableSkeleton(viewController: self)
                        self.dynamicPostsList = []
                        self.noResultView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
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
        
        if dynamicPostsList.indices.contains(indexPath.row) {
            let element = dynamicPostsList[indexPath.row]
            
            cell.titleLabel.text = element.title
            cell.scoreValue.text = String(element.score)
            cell.commentValue.text = String(element.commentCount)
            
            if let urlUnwrapped = element.url {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == postsList.count - 1 {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section == lastSectionIndex, indexPath.row == lastRowIndex {
                pagination()
            }
        }
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.searchQueue.cancelAllOperations()
            self.searchQueue.addOperation { [weak self] in
                self?.searchingPosts(searchText: searchText)
            }
        }else {
            self.searchQueue.cancelAllOperations()
            self.noResultView.isHidden = true
            self.dynamicPostsList = self.postsList
            self.tableView.reloadData()
        }
    }
}

