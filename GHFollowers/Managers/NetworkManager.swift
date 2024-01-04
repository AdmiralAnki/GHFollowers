//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Ankith K on 24/11/23.
//

import UIKit


class NetworkManager{
    static let shared = NetworkManager()
    static let cache = NSCache<NSString,UIImage>()
    
    private init(){}
    
    func createURLRequest(endpoint:API)->URLRequest?{
                
        var component = URLComponents()
        component.host = endpoint.baseURL
        component.path = endpoint.path
        component.scheme = endpoint.httpScheme.rawValue
        component.queryItems = endpoint.queryParams
        
        guard let url = component.url else{ return nil}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        urlRequest.httpBody = endpoint.httpBody
        
        if let headers = endpoint.headerParam{
            for (headerKey,headerValue) in headers{
                urlRequest.addValue(headerValue, forHTTPHeaderField: headerKey)
            }
        }
        
        return urlRequest
    }
    
    func makeNetworkRequest<T:Codable>(endpoint:API)async -> (Result<T,Error>) {
        
        guard let request = createURLRequest(endpoint: endpoint) else {return .failure(NSError(domain: "Error Creating Request", code: 452))}
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.waitsForConnectivity = true
        
        let urlSession = URLSession(configuration: configuration)
        
        do{
            let result = try await urlSession.data(for: request)
            let data  = result.0
            let jsonDecoder = JSONDecoder()
            
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedUserData = try jsonDecoder.decode(T.self, from: data)
            
            return .success(decodedUserData)
        }catch{
            return .failure(error)
        }
        
    }
    
    func makeNetworkRequest<T:Codable>(endpoint:API,completed:@escaping (Result<[T],GFError>)->()){
        guard let request = createURLRequest(endpoint: endpoint) else {
            completed(.failure(.requestError))
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.waitsForConnectivity = true
        
        let urlSession = URLSession(configuration: configuration)
        
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error{
//                completed(.failure(error as! GFError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 
            else{
                completed(.failure(.invalidStatusCode))
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.dataNotReceived))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let followers = try decoder.decode([T].self, from: data)
                completed(.success(followers))
                return
            }catch{
//                completed(.failure(error))
                return
            }
            
            
        }.resume()
    }
    
}



enum GFError:String, Error{
    case requestError               = "Error creating Request"
    case decodingError              = "Failed to decode data"
    case dataNotReceived            = "Data not received"
    case invalidStatusCode          = "Invalid status code"
    case failedToRetreiveFavourites = "Couldn't retreive favorites!"
    case unableToFavourite          = "Unable to favourite"
    case userAlreadyFavourited      = "This user is already in your favourites!"
    
}
