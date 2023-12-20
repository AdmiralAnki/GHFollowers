//
//  FollowerImage.swift
//  GHFollowers
//
//  Created by Ankith K on 25/11/23.
//

import UIKit

class FollowerImage: UIImageView {

    let placeHolderImage = UIImage(named: "gh-placeholder")!
    let cache = NetworkManager.cache
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(from urlString:String) async{
        
        let cacheKey = NSString(string: urlString)        
        if let image = cache.object(forKey: cacheKey){
            
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        
        do{
            let response = try await URLSession.shared.data(from: url)
            guard let httpResponse = response.1 as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {return}
            
            guard let image = UIImage(data: response.0) else {return}
            
            cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }catch{
            return
        }
        
    }

}


#Preview{
    let image = FollowerImage(frame: .zero)
    
    NSLayoutConstraint.activate([
        image.widthAnchor.constraint(equalToConstant: 200),
        image.heightAnchor.constraint(equalToConstant: 200)
    ])
    
    return image
}
