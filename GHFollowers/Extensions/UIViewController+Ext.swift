//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import UIKit
import SafariServices


	
extension UIViewController{
    
    func presentSafariViewController(url:URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        
        self.present(safariVC,animated: true)
    }
    
    func presentGFAlertOnMainThread(title:String,message:String,buttonTitle:String){
        DispatchQueue.main.async{
            let alert = GFAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert,animated: true)
        }
    }
    
    
}
