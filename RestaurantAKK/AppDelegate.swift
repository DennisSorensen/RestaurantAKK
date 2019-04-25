//
//  AppDelegate.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Laver en cache
        //Pegepind til appen temp bibliotek
        let tempDirectory = NSTemporaryDirectory()
        //Definerer et urlCache obj med ca 25mb i hukommelse og ca 50mb i disk
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: tempDirectory)
        //Så fortæller vi URLCache.shared hvor meget memory den må bruge via vores obj
        URLCache.shared = urlCache
        
        //Sætter os som delegate, til sådan vi kan sende notifikationer når appen kører
        UNUserNotificationCenter.current().delegate = self
        //Spørger om vi så sende notifikationer
        tilladNotifikationer()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate : UNUserNotificationCenterDelegate { //Protokol er til hvis man vil sende notifikationer når man er inden i appen
    //Func der spørger om lov til at forstyrre brugeren med en notifikation
    func tilladNotifikationer() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (ok, error) in
            if ok {
                print("Vi må sende notifikationer")
            }
            else {
                if let fejl = error {
                    print(fejl.localizedDescription)
                }
            }
        }
    }
    
    //Funktion der tillader at vi viser notifikationer mens appen kører
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound]) //Fortæller hvilke options vi vil reagere på mens appen kører
    }
    
//    //Hvis vi vil sende brugeren et bestemt sted hen ved trykken på notifikationen
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        response.notification.request.identifier == "" //Det er identifieren på vores notifikationsId, som vi kan spørge på den og så man kan hoppe det rigtige sted hen
//    }
}
