//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Ankith on 11/01/24.
//

import UIKit

extension UIView{
    
    func addSubviews(_ views:UIView...){
        for view in views{ addSubview(view) }
    }
}
