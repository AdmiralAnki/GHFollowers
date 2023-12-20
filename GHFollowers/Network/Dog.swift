//
//  Dog.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import Foundation

enum Dog:API{
    
    
    case getDogs
    
    var httpMethod: HTTPMethod{
        switch self{
        case .getDogs:
            return .get
        }
    }
    
    var httpScheme: HTTPScheme{
        switch self{
        case .getDogs:
            return .https
        }
    }
    
    var baseURL: String{
        switch self{
        case .getDogs:
            return "api.dogs.com"
        }
    }
    
    var path: String{
        switch self{
        case .getDogs:
            return "/randomDog"
        }
    }
    
    var queryParams: [URLQueryItem]?{
        switch self{
        case .getDogs:
            return nil
        }
    }
    
    var headerParam: [String : String]?{
        switch self{
        case .getDogs:
            return ["auth":"493939393939393"]
        }
    }
    
    var httpBody: Data?{
        switch self{
        case .getDogs:
            return nil
        }
    }
    

    
}
