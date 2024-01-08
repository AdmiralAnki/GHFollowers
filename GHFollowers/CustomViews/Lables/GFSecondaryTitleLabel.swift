//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by Ankith on 30/12/23.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
    }
    
    convenience init(fontSize:CGFloat){
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure(){
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9  //when username is too long shrink it to 90%
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}
