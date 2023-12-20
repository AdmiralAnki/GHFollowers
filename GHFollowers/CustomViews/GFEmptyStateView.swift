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
    
    init(message:String){
        super.init(frame: .zero)
        label.text = message
        configure()
    }
    
    func configure(){
        addSubview(label)
        addSubview(image)
        
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        
        label.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "empty-state-logo")
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -140),
            label.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -40),
            label.heightAnchor.constraint(equalToConstant: 200),
            
            image.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            image.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 180),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 100)
        ])
    }
    
}


#Preview{
    let emptyState = GFEmptyStateView(message: "This user does not have any followers.  😀")
    emptyState.frame = CGRect(x: 0, y: 0, width: 450, height: 650)
    
    return emptyState
}
