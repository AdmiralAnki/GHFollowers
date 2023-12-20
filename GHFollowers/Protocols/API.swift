//
//  API.swift
//  GHFollowers
//
//  Created by Ankith K on 23/11/23.
//

import Foundation

protocol API{
    
    var httpMethod:HTTPMethod { get }
    var httpScheme:HTTPScheme { get }
    var baseURL:String {get}
    var path:String {get}
    
    var queryParams:[URLQueryItem]? {get}
    var headerParam:[String:String]? {get}
    var httpBody:Data? {get}
}

enum HTTPMethod:String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


enum HTTPScheme:String{
    case http = "http"
    case https = "https"
}


