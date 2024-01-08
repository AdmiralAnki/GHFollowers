//
//  API.swift
//  MediaGallery
//
//  Created by Ankith on 07/01/24.
//

import Foundation

protocol API{
    var httpMethod:HTTPMethod {get}
    var httpScheme:HTTPScheme {get}
    var path:String {get}
    var host:String {get}
    var body:Data? {get}
    var queryParams:[URLQueryItem]? {get}
    var headerParama:[String:String]? {get}
}


enum HTTPMethod:String{
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}


enum HTTPScheme:String{
    case http   = "http"
    case https  = "https"
}
