//
//  FavouriteCell.swift
//  GHFollowers
//
//  Created by Ankith on 05/01/24.
//

import UIKit

class FavouriteCell: UITableViewCell {

    static let reuseID = "FavouriteCell"
    let avatarImageView = GFFollowerImageView(frame: .zero)
    let username = GFTitleLabel(textAlignment: .left, fontSize: 26)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favourite:Follower){
        self.username.text = favourite.login
        Task{
          await self.avatarImageView.downloadImage(from: favourite.avatarUrl)
        }
    }
    
    
    private func configure(){
        addSubview(avatarImageView)
        addSubview(username)
        
        accessoryType           = .disclosureIndicator
        let padding:CGFloat     = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            
            username.centerYAnchor.constraint(equalTo: centerYAnchor),
            username.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            username.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            username.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
        
    }
}
