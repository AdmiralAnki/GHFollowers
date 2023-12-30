//
//  Users.swift
//  GHFollowers
//
//  Created by Ankith K on 24/11/23.
//

import Foundation

struct Users:Codable{
    
    let login:String
    let avatarUrl:String
    var name:String?
    var location:String?
    var bio:String?
    let publicRepos:Int
    let publicGists:Int
    let htmlUrl:String
    let following:Int
    let followers:Int
    let createdAt:String
}
