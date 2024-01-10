//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
    }
    
    
    convenience init(textAlignment:NSTextAlignment){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }

    private func configure(){
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        font = UIFont.preferredFont(forTextStyle: .body)
        minimumScaleFactor = 0.75  //when username is too long shrink it to 75% to make sure it fits
        lineBreakMode = .byWordWrapping // when username is too long shrink it to 90% and then truncate tail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
