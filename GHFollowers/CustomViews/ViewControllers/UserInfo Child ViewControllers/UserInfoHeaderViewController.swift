//
//  UserInfoHeaderViewController.swift
//  GHFollowers
//
//  Created by Ankith on 30/12/23.
//

import UIKit

class UserInfoHeaderViewController: UIViewController {

    let avatarImageView     = GFFollowerImageView(frame: .zero)
    let username            = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let name                = GFSecondaryTitleLabel(fontSize: 18)
    let locationPin         = UIImageView()
    let userLocation        = GFSecondaryTitleLabel(fontSize: 18)
    let bio                 = GFBodyLabel(textAlignment: .left)
    
    var user:Users!
    
    init(user: Users) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        layoutUI()
        configureUI()
    }

    func addSubViews(){
        view.addSubviews(avatarImageView,username,name,locationPin,userLocation,bio)
        
        let subviews = [avatarImageView,username,name,locationPin,userLocation,bio]
        for subview in subviews {        
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func layoutUI(){
        let textImagePadding:CGFloat = 12

        locationPin.image = SFSymbols.loaction
        locationPin.tintColor = .secondaryLabel
        
        bio.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            
            username.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            username.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            username.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            username.heightAnchor.constraint(equalToConstant: 38),
            
            name.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor,constant: 6),
            name.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,constant: textImagePadding),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            name.heightAnchor.constraint(equalToConstant: 20),
            
            locationPin.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationPin.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationPin.heightAnchor.constraint(equalToConstant: 20),
            locationPin.widthAnchor.constraint(equalToConstant: 20),
            
            userLocation.bottomAnchor.constraint(equalTo:avatarImageView.bottomAnchor),
            userLocation.leadingAnchor.constraint(equalTo: locationPin.trailingAnchor,constant:textImagePadding),
            userLocation.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            userLocation.heightAnchor.constraint(equalToConstant: 20),
            
            bio.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            bio.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bio.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bio.heightAnchor.constraint(equalToConstant: 95)
        ])
    }
    
    func configureUI(){
        Task{
            let image = await NetworkManager.downloadImage(from: user.avatarUrl)
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
        
        username.text = user.login
        name.text = user.name ?? ""
        userLocation.text = user.location ?? "Not available"
        bio.text = user.bio ?? "Not available"
    }
}

