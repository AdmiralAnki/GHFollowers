//
//  FollowersViewController.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit
import CryptoKit

class FollowersViewController: UIViewController {

    enum Section{
        case main
    }
    
    var page = 1
    var hasMoreFollowers = true
    var username = ""
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var isSearchActive = false
    var collectionView:UICollectionView!
    var datasource:UICollectionViewDiffableDataSource<Section,Follower>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confgureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getFollwers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
        
    func confgureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureDataSource(){
        datasource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search a user"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
//        searchController.searchBar.showsCancelButton = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    func updateDataSet(on followers:[Follower]){
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([Section.main])
        snapShot.appendItems(followers)
        datasource.apply(snapShot)
    }
    
    func getFollwers(username:String,page:Int) {
        
        showLoadingView()
        Task{
            let decodedToken = Helper.getAuthToken(encryptedToken: authToken)
            let result:Result<[Follower],Error> = await NetworkManager.shared.makeNetworkRequest(endpoint: GitHub.followers(name: username, pageSize: 80, pageNo: page, authToken: decodedToken))
            
            dismissLoadingView()
            switch result{
            case .success(let users):
                if users.count < 80{ hasMoreFollowers = false }
                followers.append(contentsOf: users)
                
                if followers.isEmpty {
                     DispatchQueue.main.async {
                        self.showEmptyStateView(message: "This user doesn't have any followers, give them a follow 😀", on: self.view)
                    }
                    return
                }
                
                updateDataSet(on: followers)
            case .failure(let error):
                presentAFAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
        
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in:view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
}

extension FollowersViewController:UICollectionViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard hasMoreFollowers else {return}
        
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if contentOffset > (contentHeight-height){
            print("reached end load new data")
            page += 1
            getFollwers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = isSearchActive ? filteredFollowers[indexPath.item] : followers[indexPath.item]
                
        let destinationViewController = UserInfoViewController()
        destinationViewController.username = follower.login
        let destination = UINavigationController(rootViewController: destinationViewController)
        present(destination,animated: true)
        
    }
    
 
}


extension FollowersViewController:UISearchResultsUpdating,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else  {return}
        
        isSearchActive = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateDataSet(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateDataSet(on: followers)
        isSearchActive = false
    }
}
