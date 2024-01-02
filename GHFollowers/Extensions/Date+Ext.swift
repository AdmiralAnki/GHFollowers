//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Ankith on 02/01/24.
//

import Foundation

extension Date{
    
    func convertToMonthYearFormat()->String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM yyyy"        
        return dateformatter.string(from: self)
    }
    
}
