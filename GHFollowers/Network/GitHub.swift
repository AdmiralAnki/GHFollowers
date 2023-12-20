//
//  GitHub.swift
//  GHFollowers
//
//  Created by Ankith K on 24/11/23.
//

import Foundation


enum GitHub:API{
    
    
    case users(name:String,authToken:String)
    
    case followers(name:String,pageSize:Int,pageNo:Int,authToken:String)
    
    var httpMethod: HTTPMethod{
        switch self{
        case .users,.followers:
            return .get
        }
    }
    
    var httpScheme: HTTPScheme{
        switch self{
        case .users,.followers:
            return .https
        }
    }
    
    var baseURL: String{
        switch self{
        case .users,.followers:
            return "api.github.com" //ideally this will be stored somewhere else
        }
    }
    
    var path: String{
        switch self{
        case .users(let name, _):
            return "/users/"+name
        case .followers(let name, _,_,_):
            return "/users/\(name)/followers"
        }
    }
    
    var queryParams: [URLQueryItem]?{
        switch self{
        case .users:
            return nil
            
        case .followers(_,let pageSize,let pageNo, _):
            return [URLQueryItem(name: "per_page", value: "\(pageSize)"),URLQueryItem(name: "page", value: "\(pageNo)")]
        }
    }
    
    var headerParam: [String : String]?{
        switch self{
        case .users( _, let authToken),.followers(_,_,_, let authToken):
            return ["Accept":"application/vnd.github+json",
                    "Authorization":"Bearer "+authToken,
                    "X-GitHub-Api-Version": "2022-11-28"]
        }
    }
    
    var httpBody: Data?{
        switch self{
        case .users,.followers:
            return nil
            
        }
    }
}
    
