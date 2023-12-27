//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Ankith on 27/12/23.
//

import UIKit

class UserInfoViewController: UIViewController {

    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(username)
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        
        navigationItem.setRightBarButton(doneButton, animated: true)
    }

    @objc func dismissVC(){
        self.dismiss(animated: true)
    }
}
