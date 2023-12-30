//
//  Helper.swift
//  GHFollowers
//
//  Created by Ankith on 28/12/23.
//

import Foundation
import CryptoKit

class Helper{
    
    static func getAuthToken(encryptedToken:String)->String{
        
        let data = Data(base64Encoded: "dGhpcyBpcyBteSBzZWNyZXQgd2l0aCBhIHNpemUgMzI=")
        let key = SymmetricKey(data: data!)
        let encryptedContent = Data(base64Encoded: encryptedToken)
        
        let sealedBox = try! ChaChaPoly.SealedBox(combined: encryptedContent!)
        
        let decryptedThemeSong = try! ChaChaPoly.open(sealedBox, using: key)

        let encodedToken = decryptedThemeSong.base64EncodedString()
        
        guard let data = Data(base64Encoded: encodedToken) else {return ""}
        if let decodedToken = String(data: data, encoding: .utf8){
            return decodedToken
        }else{
            return ""
        }
    }
}
