//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Ankith K on 25/11/23.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseID  = "FollowerCell"
    let followerImage   = GFFollowerImageView(frame: .zero)
    let username        = GFTitleLabel(textAlignment: .center, fontSize: 16)
        
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
    }
    
    func set(follower:Follower){
        self.username.text = follower.login
        Task{
            let image = await NetworkManager.downloadImage(from: follower.avatarUrl)
            DispatchQueue.main.async {
                self.followerImage.image = image
            }
        }
    }
    
    private func configure(){
        
        addSubviews(followerImage,username)
        
        let padding:CGFloat = 8
 
        NSLayoutConstraint.activate([
            followerImage.topAnchor.constraint(equalTo:topAnchor,constant: padding),
            followerImage.leadingAnchor.constraint(equalTo:leadingAnchor,constant: padding),
            followerImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            followerImage.heightAnchor.constraint(equalTo: followerImage.widthAnchor),
            
            username.topAnchor.constraint(equalTo: followerImage.bottomAnchor, constant: 8),
            username.widthAnchor.constraint(equalTo: followerImage.widthAnchor),
            username.centerXAnchor.constraint(equalTo: centerXAnchor),
            username.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
}


#Preview{
    let cell = FollowerCell(frame: .zero)
    
    NSLayoutConstraint.activate([
        cell.widthAnchor.constraint(equalToConstant: 280),
        cell.heightAnchor.constraint(equalToConstant: 320)
    ])
    
    return cell
}
