//
//  GFAlertContainerView.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit

class GFAlertContainerView: UIView {
  
   override init(frame:CGRect){
        super.init(frame: frame)
       configure()
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
    }
    
    
    init(){
        super.init(frame: .zero)
        configure()
    }
    
    private func configure(){
        backgroundColor = .systemBackground
        layer.cornerRadius = 14
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
