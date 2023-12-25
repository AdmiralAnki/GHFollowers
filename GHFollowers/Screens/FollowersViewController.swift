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
        searchController.searchBar.showsCancelButton = true
        searchController.obscuresBackgroundDuringPresentation = true
        
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
            let decodedToken = getAuthToken(encryptedToken: authToken)
            let result:Result<[Follower],Error> = await NetworkManager.shared.makeNetworkRequest(endpoint: GitHub.followers(name: username, pageSize: 80, pageNo: page, authToken: decodedToken))
            
            dismissLoadingView()
            switch result{
            case .success(let users):
                if users.count < 80{ hasMoreFollowers = false }
                followers.append(contentsOf: users)
                
                if followers.isEmpty {
                    print("Thread is main: ",Thread.isMainThread)
                    
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
        
        print("ContentOffset: \(contentOffset),\n contentHeight: \(contentHeight),\n height:\(height)")
        
        if contentOffset > (contentHeight-height){
            print("reached end load new data")
            page += 1
            getFollwers(username: username, page: page)
        }
     
    }
    
    func getAuthToken(encryptedToken:String)->String{
        
        let data = Data(base64Encoded: "dGhpcyBpcyBteSBzZWNyZXQgd2l0aCBhIHNpemUgMzI=")
        let key = SymmetricKey(data: data!)
        let encryptedContent = Data(base64Encoded: encryptedToken)
        
        let sealedBox = try! ChaChaPoly.SealedBox(combined: encryptedContent!)
        
        let decryptedThemeSong = try! ChaChaPoly.open(sealedBox, using: key)

        let encodedToken = decryptedThemeSong.base64EncodedString()
        
        guard let data = Data(base64Encoded: encodedToken) else {return ""}
        if let decodedToken = String(data: data, encoding: .utf8){
            return decodedToken
        }else{
            return ""
        }
    }
}


extension FollowersViewController:UISearchResultsUpdating,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else  {return}
        
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateDataSet(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateDataSet(on: followers)
    }
}
