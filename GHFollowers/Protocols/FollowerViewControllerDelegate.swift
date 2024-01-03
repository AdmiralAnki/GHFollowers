//
//  FollowerListViewControllerDelegate.swift
//  GHFollowers
//
//  Created by Ankith on 03/01/24.
//

import Foundation

protocol FollowerViewControllerDelegate:AnyObject{
    func didRequestFollowers(for username:String)
}
