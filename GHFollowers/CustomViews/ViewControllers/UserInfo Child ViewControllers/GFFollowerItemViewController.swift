//
//  GFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by Ankith on 02/01/24.
//

import UIKit

class GFFollowerItemViewController: GFInfoItemViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }

    private func configureItems(){
        itemInfoViewOne.setupInfoItem(itemType: .following , with: user.following)
        itemInfoViewTwo.setupInfoItem(itemType: .followers, with: user.followers)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
   
}
