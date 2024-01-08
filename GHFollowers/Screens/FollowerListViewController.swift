//
//  FollowersViewController.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit
import CryptoKit

class FollowerListViewController: UIViewController {

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
    
    
    init(username:String){
        super.init(nibName: nil, bundle: nil)
        self.username = username
        self.title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.setRightBarButton(addButton, animated: true)
        
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
                presentGFAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
        
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in:view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    @objc func addButtonTapped(){
        Task{
            let decodedToken = Helper.getAuthToken(encryptedToken: authToken)
            let result:Result<Users,Error> = await NetworkManager.shared.makeNetworkRequest(endpoint: GitHub.users(name: username, authToken: decodedToken))
            
            switch result{
            case .success(let user):
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateFavouitesWith(follower: follower, actionType: .add) { error in
                    guard let error = error else{
                        self.presentGFAlertOnMainThread(title: "Added to favourite", message: "You have successfully added this user to favourites 🎉", buttonTitle: "Yay!")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
                
            }
        }
    }
}

extension FollowerListViewController:UICollectionViewDelegate{
    
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
        destinationViewController.delegate = self
        
        let destination = UINavigationController(rootViewController: destinationViewController)
        present(destination,animated: true)
        
    }
    
 
}


extension FollowerListViewController:UISearchResultsUpdating,UISearchBarDelegate{
    
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

extension FollowerListViewController:FollowerViewControllerDelegate{
    func didRequestFollowers(for username: String) {
        // get followers for that user
        self.username = username
        self.title = username
        
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        DispatchQueue.main.async{
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
        getFollwers(username: username, page: page)
        
    }
}
