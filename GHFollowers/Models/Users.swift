//
//  Users.swift
//  GHFollowers
//
//  Created by Ankith K on 24/11/23.
//

import Foundation

struct Users:Codable{
    
    var login:String
    var avatarUrl:String
    var name:String?
    var location:String?
    var bio:String?
    var publicRepos:Int
    var publicGists:Int
    var htmlUrl:String
    var following:Int
    var followers:Int
    var createdAt:String
}
