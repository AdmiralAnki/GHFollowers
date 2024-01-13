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
            jsonDecoder.dateDecodingStrategy = .iso8601
            
            let decodedUserData = try jsonDecoder.decode(T.self, from: data)
            
            return .success(decodedUserData)
        }catch{
            return .failure(error)
        }
        
    }
    
    static func downloadImage(from urlString:String) async -> UIImage?{
        
        let cacheKey = NSString(string: urlString)
        
        if let image = NetworkManager.cache.object(forKey: cacheKey){
            return image
        }
        
        guard let url = URL(string: urlString) else {return nil}
        
        do{
            let response = try await URLSession.shared.data(from: url)
            guard let httpResponse = response.1 as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let image = UIImage(data: response.0) else {return nil}
            
            NetworkManager.cache.setObject(image, forKey: cacheKey)
            return image
                        
        }catch{
            return nil
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
            
            if let error {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 
            else{
                completed(.failure(.invalidStatusCode))
                return
            }
            
            
            guard let data else {
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
