//
//  MadRet.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 27/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import Foundation

//bare en kommentar....

struct MadRet : Codable {
    
    //Det er det rå format som det ser ud fra json
//    var description : String
//    var name : String
//    var image_url : String
//    var id : Int
//    var price : Double
//    var category : String
    
    //Vores interne felt navne
    var beskrivelse : String
    var navn : String
    var billedUrl : URL
    var retNummer : Int
    var pris : Double
    var kategori : String
    
    //Til at mappe dem over fra json til de interne felter
    enum CodingKeys : String, CodingKey {
        case beskrivelse = "description"
        case navn = "name"
        case billedUrl = "image_url"
        case retNummer = "id"
        case pris = "price"
        case kategori = "category"
    }
    
    //Fordi vi bruger alle felter, så skal vi ikke bruge init(from:)
}

//Bruger til at få menukortet i
struct MadRetter : Codable {
    let madretter : [MadRet]
    
    enum CodingKeys : String, CodingKey {
        case madretter = "items"
    }
}
