//
//  OrdreBrkraeftelse.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 27/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import Foundation

struct OrdreBrkraeftelse : Codable {
    let tilberedningstid : Int
    
    enum CodingKeys : String, CodingKey {
        case tilberedningstid = "preparation_time"
    }
}
