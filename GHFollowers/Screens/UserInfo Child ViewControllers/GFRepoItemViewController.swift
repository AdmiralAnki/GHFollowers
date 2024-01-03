//
//  GFRepoItemViewController.swift
//  GHFollowers
//
//  Created by Ankith on 02/01/24.
//

import UIKit

class GFRepoItemViewController: GFInfoItemViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
        configureActionButton()
    }

    private func configureItems(){
        itemInfoViewOne.setupInfoItem(itemType: .repos, with: user.publicRepos)
        itemInfoViewTwo.setupInfoItem(itemType: .gists, with: user.publicGists)
    }
    
    private func configureActionButton(){
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGithubProfile(for: user)
    }

}
