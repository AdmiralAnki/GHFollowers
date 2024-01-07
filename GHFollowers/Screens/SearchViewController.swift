//
//  ViewController.swift
//  GHFollowers
//
//  Created by Ankith K on 15/11/23.
//

import UIKit
import CryptoKit

class SearchViewController: UIViewController {
    
    let imageView = UIImageView()
    let button = GFButton(color: .systemGreen, title: "Sign Up")
    let textField = GFTextField()
    
    var isUsernameEntered:Bool{
        return !textField.text!.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        view.backgroundColor = .darkGray
        
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(textField)
        
        textField.delegate = self
        addButtonAction()
        
        addTapGestureRecogniser()
        
        configureImageView()
        addConstraintToTextField()
        addConstraintToButton()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func addTapGestureRecogniser(){
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapAction(){
        view.endEditing(true)
    }
    
    
    
    func addButtonAction(){
        button.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
    }
    
    
    @objc func showFollowers(){
        
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty username", message: "Please enter a valid username. We need to know who to look for 😀", buttonTitle: "Ok")
            return
        }
        
        let followersVC = FollowerListViewController()
        followersVC.username = textField.text!
        followersVC.title = textField.text!
        
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    
    func configureImageView(){
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addConstraintToTextField(){
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: 260),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    func addConstraintToButton(){
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 260),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }


}


extension SearchViewController:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn: ")
        
        showFollowers()
        return true
    }
    
    
}
