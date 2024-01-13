//
//  GFButton.swift
//  GHFollowers
//
//  Created by Ankith K on 15/11/23.
//

import Foundation
import UIKit


class GFButton:UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(color:UIColor,title:String,systemImageName: String){
        self.init(frame: .zero)
        set(backgroundColor: color, title: title, systemImageName: systemImageName)
    }
    
    func configure(){
        
        configuration = .borderedTinted()
        configuration?.buttonSize = .medium
        configuration?.cornerStyle = .medium
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor:UIColor,title:String,systemImageName:String){
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.baseForegroundColor = backgroundColor
        configuration?.title = title
        
        configuration?.image = UIImage(systemName:systemImageName)
        configuration?.imagePlacement = .leading
        configuration?.imagePadding = 5
    }
}

#Preview{
    let button = GFButton(color: .systemGreen, title: "Click here", systemImageName: "person")
    
    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 280),
        button.heightAnchor.constraint(equalToConstant: 55)
    ])
    
    return button
}

#Preview{
    let button = GFButton(color: .systemCyan, title: "Click cyan", systemImageName: "magnifyingglass")
    
    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 280),
        button.heightAnchor.constraint(equalToConstant: 55)
    ])
    
    return button
}
