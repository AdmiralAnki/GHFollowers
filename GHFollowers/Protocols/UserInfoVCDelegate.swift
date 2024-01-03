//
//  UserInfoVCDelegate.swift
//  GHFollowers
//
//  Created by Ankith on 03/01/24.
//

import Foundation

protocol UserInfoVCDelegate:AnyObject{
    func didTapGithubProfile(for user:Users)
    func didTapGetFollowers(for user:Users)
}
