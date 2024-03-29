//
//  FollowersViewController.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit
import CryptoKit

class FollowerListViewController: GFDataLoadingViewController {

    enum Section{
        case main
    }
    
    var collectionView:UICollectionView!
    var datasource:UICollectionViewDiffableDataSource<Section,Follower>!
    
    var page                = 1
    var hasMoreFollowers    = true
    var username            = ""
    var isSearchActive      = false
    
    var followers           = [Follower]()
    var filteredFollowers   = [Follower]()
   
    
    
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
                updateUI(users)
                
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
    
    fileprivate func updateUI(_ users: [Follower]) {
        if users.count < 80{ hasMoreFollowers = false }
        followers.append(contentsOf: users)
        updateDataSet(on: followers)
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
    @objc func addButtonTapped(){
        Task{
            let decodedToken = Helper.getAuthToken(encryptedToken: authToken)
            let result:Result<Users,Error> = await NetworkManager.shared.makeNetworkRequest(endpoint: GitHub.users(name: username, authToken: decodedToken))
            
            switch result{
            case .success(let user):
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateFavouitesWith(follower: follower, actionType: .add) { error in
                    guard let error else{
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
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if followers.isEmpty && !hasMoreFollowers{
            var config = UIContentUnavailableConfiguration.empty()
            config.text = "No followers"
            config.secondaryText = "This user doesn't have any followers, give them a follow 😀"
            config.image = .init(systemName: "person.slash.fill")
            contentUnavailableConfiguration = config
        }else if isSearchActive && filteredFollowers.isEmpty{
            contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
        }
        else{
            contentUnavailableConfiguration = nil
        }
    }
 
}


extension FollowerListViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else  {
        
            filteredFollowers.removeAll()
            updateDataSet(on: followers)
            isSearchActive = false
            return
        }
        
        isSearchActive = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateDataSet(on: filteredFollowers)
        setNeedsUpdateContentUnavailableConfiguration()
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
