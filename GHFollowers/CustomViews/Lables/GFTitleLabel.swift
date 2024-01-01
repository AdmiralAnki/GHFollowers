//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit

class GFTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }
    
    
    init(textAlignment:NSTextAlignment,fontSize:CGFloat){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    private func configure(){
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9  //when username is too long shrink it to 90%
        lineBreakMode = .byTruncatingTail // when username is too long shrink it to 90% and then truncate tail
        translatesAutoresizingMaskIntoConstraints = false       
    }

}
