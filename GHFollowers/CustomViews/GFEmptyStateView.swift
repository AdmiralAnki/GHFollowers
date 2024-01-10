//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Ankith K on 18/12/23.
//

import UIKit

class GFEmptyStateView: UIView {

    let label = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let image = UIImageView(frame: .zero)
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message:String){
        self.init(frame: .zero)
        label.text = message
    }
    
    fileprivate func configureImageView() {
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: Images.emptyState.rawValue)
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            image.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 180),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 100)
        ])
    }
    
    fileprivate func configureLabel() {
        addSubview(label)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -140),
            label.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -40),
            label.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configure(){
        configureImageView()
        configureLabel()
    }
    
}


#Preview{
    let emptyState = GFEmptyStateView(message: "This user does not have any followers.  😀")
    emptyState.frame = CGRect(x: 0, y: 0, width: 450, height: 650)
    
    return emptyState
}
