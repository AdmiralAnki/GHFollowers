//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Ankith K on 20/11/23.
//

import Foundation
import UIKit

class GFTextField:UITextField{
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    
    init(placeHolder:String){
        super.init(frame: .zero)
        
        self.placeholder = placeHolder
        configure()
    }
    
    func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
        self.placeholder = "Enter a username"
        
        layer.cornerRadius = 14
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        
        returnKeyType = .go
        
//        clearButtonMode = .whileEditing
    }
}

#Preview{
    let text = GFTextField(placeHolder: "Enter a name")
    
    NSLayoutConstraint.activate([
        text.widthAnchor.constraint(equalToConstant: 280),
        text.heightAnchor.constraint(equalToConstant: 55)
    ])
    
    return text
}
