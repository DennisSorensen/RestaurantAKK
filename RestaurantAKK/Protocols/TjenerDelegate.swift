//
//  TjenerDelegate.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/02/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import Foundation

//At tilføje madretten til ordren vi i bestillingsskærmbilledet uddelegere
//Alt. vil det være en tjener som skriver på odreseddlen
protocol TjenerDelegate {
    func madRetTilOrdren(madRet: MadRet)
}
