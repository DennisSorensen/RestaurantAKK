//
//  OrdreSeddel.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 20/04/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import Foundation

struct OrdreSeddel {
    var madRetter : [MadRet]
    
    //Init som kan lave en ordreseddel ud fra et array af madretter
    init(madRetter: [MadRet] = []) {
        self.madRetter = madRetter
    }
    
    //Funktion der tilføjer madretter til ordren
    public mutating func tilføjMadRet(madRet: MadRet) {
        self.madRetter.append(madRet)
    }
}
