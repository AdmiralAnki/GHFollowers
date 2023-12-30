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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        
        navigationItem.setRightBarButton(doneButton, animated: true)
        layoutHeaderView()
        let decodedToken = Helper.getAuthToken(encryptedToken: authToken)
        
        Task{
            
            let result:Result<Users,Error> = await NetworkManager.shared.makeNetworkRequest(endpoint: GitHub.users(name: username, authToken: decodedToken) )
            
            switch result{
            case .success(let user):
                DispatchQueue.main.async{
                    self.addChildVC(childVC: UserInfoHeaderViewController(user: user), to: self.headerView)
                }
            case .failure(let error):
                presentAFAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }

        
    }
    
    
    func layoutHeaderView(){
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.backgroundColor = .purple
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    func addChildVC(childVC viewController:UIViewController, to containerView:UIView){
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.didMove(toParent: self)
    }
    
    
    @objc func dismissVC(){
        self.dismiss(animated: true)
    }
}

#Preview{
    UserInfoViewController()
}
