//
//  MainTabBarController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 25/04/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class MainTabBarController {
    
    //Vi laver en variabel som indeholder det faneblad som ordreseddlen ligger på
    public private(set) var ordreTabBarItem : UITabBarItem?
    
    init() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let førsteViewController = appDelegate.window!.rootViewController! as! UITabBarController
        ordreTabBarItem = førsteViewController.viewControllers![1].tabBarItem
    }
    
    @objc func opdaterBadge() {
        let badgeTekst = RestaurantController.shared.aktuelOrdre.madRetter.count > 0 ? "\(RestaurantController.shared.aktuelOrdre.madRetter.count)" : nil
        self.ordreTabBarItem?.badgeValue = badgeTekst
    }
    
    public func tilmeldObserver() {
        //Jeg vil have besked når ordreseddlen opdateres
        NotificationCenter.default.addObserver(self, selector: #selector(opdaterBadge), name: RestaurantController.ordreOpdNotifikationsNavn, object: nil)
    }
    
    //MARK: STATIC
    static let shared = MainTabBarController()
}
