//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Ankith on 27/12/23.
//

import UIKit

class UserInfoViewController: UIViewController {

    var username = ""
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var itemArray:[UIView] = []
    
    weak var delegate:FollowerViewControllerDelegate!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutHeaderView()
        getUser()
    }
    
    fileprivate func getUser() {
        let decodedToken = Helper.getAuthToken(encryptedToken: authToken)
        showLoadingView()
        Task{
            
            let result:Result<Users,Error> = await NetworkManager.shared.makeNetworkRequest(endpoint: GitHub.users(name: username, authToken: decodedToken) )
            
            switch result{
            case .success(let user):
                DispatchQueue.main.async{
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                presentAFAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    fileprivate func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    func configureUIElements(with user:Users){
        self.dismissLoadingView()
        self.addChildVC(childVC: UserInfoHeaderViewController(user: user), to: self.headerView)
        let repoVC = GFRepoItemViewController(user: user)
        let followerVC = GFFollowerItemViewController(user: user)
        
        self.addChildVC(childVC: repoVC, to: self.itemViewOne)
        repoVC.layoutUI()
        repoVC.delegate = self
        
        self.addChildVC(childVC: followerVC, to: self.itemViewTwo)
        followerVC.layoutUI()
        followerVC.delegate = self
        
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
    }
    func layoutHeaderView(){
        itemArray = [headerView,itemViewOne,itemViewTwo,dateLabel]
       
        let padding:CGFloat = 20
        let itemSpacing:CGFloat = 12
        let itemHeight:CGFloat = 140
       
        for itemView in itemArray{
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: itemSpacing),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: itemSpacing),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func addChildVC(childVC viewController:UIViewController, to containerView:UIView){
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        print("Child view controller frame: ",containerView.bounds)
        viewController.didMove(toParent: self)
    }
    
    
    @objc func dismissVC(){
        self.dismiss(animated: true)
    }
}

extension UserInfoViewController: UserInfoVCDelegate{
    
    func didTapGithubProfile(for user: Users) {
        guard let url = URL(string: user.htmlUrl) else {
            presentAFAlertOnMainThread(title: "Invalid URL", message: "The url for this user is not valid", buttonTitle: "Ok")
            return
        }
        presentSafariViewController(url: url)
    }
    
    func didTapGetFollowers(for user: Users) {
        guard user.followers != 0 else{
            
            presentAFAlertOnMainThread(title: "Error", message: "User doesn't have any followers", buttonTitle: "Ok")
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        self.dismiss(animated: true)
        
    }
    
    
}
