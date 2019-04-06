//
//  Kategorier.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 27/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import Foundation

//struct Kategorier : Codable {
//    let kategorier : [String]
//
//    enum CodingKeys : String, CodingKey {
//        case kategorier = "categories"
//    }
//}

struct MadRetKategorier : Codable {
    let kategorier : [String]
    
    enum CodingKeys : String, CodingKey {
        case kategorier = "categories"
    }
}
