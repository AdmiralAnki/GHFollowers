//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Ankith on 04/01/24.
//

import Foundation

enum PersistenceActionType{
    case add, remove
}

enum PersistenceManager{
    
    static private let defaults = UserDefaults.standard
    
    enum Keys{
        static let favourites = "favorites"
    }
    
    static func updateFavouitesWith(follower:Follower,actionType:PersistenceActionType, completed: @escaping (GFError?)->()){
        retrieveFavouritesForKey { retrievedData in
            
            switch retrievedData{
            case .success(let followers):
                var favouriteFollowers = followers
                switch actionType{
                case .add:
                    guard !favouriteFollowers.contains(follower) else {
                        completed(.userAlreadyFavourited)
                        return
                    }
                
                    favouriteFollowers.append(follower)
                   
                case .remove:
                    favouriteFollowers.removeAll { $0.login == follower.login}
                   
                }
                
                completed(saveFavourite(favourite: favouriteFollowers))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavouritesForKey(completed: @escaping (Result<[Follower],GFError>)->()){
        
        guard let favourites = defaults.object(forKey: Keys.favourites) as? Data else{
            completed(.success([]))
            return
        }
        
        do{
            let favorites = try JSONDecoder().decode([Follower].self, from: favourites)
            completed(.success(favorites))
        }catch {
            completed(.failure(.failedToRetreiveFavourites))
        }
        
    }
    
    static private func saveFavourite(favourite:[Follower])->GFError?{
        do{
            let encoder = JSONEncoder()
            let favouriteData = try encoder.encode(favourite)
            defaults.setValue(favouriteData, forKey: Keys.favourites)
            return nil
        }catch{
            return .unableToFavourite
        }
        
    }
}
