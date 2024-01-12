//
//  FollowerImage.swift
//  GHFollowers
//
//  Created by Ankith K on 25/11/23.
//

import UIKit

class GFFollowerImageView: UIImageView {

    let placeHolderImage    = UIImage(named: Images.placeHolder.rawValue)!
    let cache               = NetworkManager.cache
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
    }
    
    private func configure(){
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    

}


#Preview{
    let image = GFFollowerImageView(frame: .zero)
    
    NSLayoutConstraint.activate([
        image.widthAnchor.constraint(equalToConstant: 200),
        image.heightAnchor.constraint(equalToConstant: 200)
    ])
    
    return image
}
