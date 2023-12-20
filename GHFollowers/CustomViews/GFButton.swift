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
    
    init(color:UIColor,title:String){
        super.init(frame: .zero)
        self.backgroundColor = color
        self.setTitle(title, for: .normal)
        configure()
    }
    
    func configure(){
        
        layer.cornerRadius = 14
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

#Preview{
    let button = GFButton(color: .systemGreen, title: "Click here")
    
    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 280),
        button.heightAnchor.constraint(equalToConstant: 55)
    ])
    
    return button
}
