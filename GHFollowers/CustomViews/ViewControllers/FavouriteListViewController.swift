//
//  FavouriteListViewController.swift
//  GHFollowers
//
//  Created by Ankith on 05/01/24.
//

import UIKit

class FavouriteListViewController: GFDataLoadingViewController {

    var tableView = UITableView()
    var favourites = [Follower]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        getFavourites()
    }
    private func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView(){
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }
    
    func getFavourites(){
        
        PersistenceManager.retrieveFavouritesForKey { [weak self] result in
            guard let self else {return}
            switch result{
            case .success(let favourites):
                
                setNeedsUpdateContentUnavailableConfiguration()
//                if favourites.isEmpty{
//                    self.showEmptyStateView(message: "You have not favorited anyone!", on: self.view)
//                }else{
                    self.favourites = favourites
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
//                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }

    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favourites.isEmpty{
            var config = UIContentUnavailableConfiguration.empty()
            config.text = "No favourites"
            config.secondaryText = "Add a favourite on the search screen"
            config.image = .init(systemName: "star")
            contentUnavailableConfiguration = config
        }else{
            contentUnavailableConfiguration = nil
        }
    }
}

extension FavouriteListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favouriteCell  = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID, for: indexPath) as! FavouriteCell
        
        favouriteCell.set(favourite: favourites[indexPath.row])
        
        return favouriteCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = favourites[indexPath.row]
        let destVC = FollowerListViewController(username: user.login)       
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        let favourite = favourites[indexPath.row]

        PersistenceManager.updateFavouitesWith(follower: favourite, actionType: .remove) { [weak self] error in
            
            guard let self else {
                return
            }
            
            guard let error else{
                self.favourites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
//                if self.favourites.isEmpty{  self.showEmptyStateView(message: "You have not favorited anyone!", on: self.view) }
                setNeedsUpdateContentUnavailableConfiguration()
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            
        }
    }
    
}
