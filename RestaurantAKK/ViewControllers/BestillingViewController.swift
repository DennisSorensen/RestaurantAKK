//
//  BestillingViewController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit
import UserNotifications //For at kunne lave notifikationer

class BestillingViewController: UIViewController {

    //Model
    var minutter : Int?
    
    @IBOutlet weak var serverSvarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let antalMinutter = minutter else {return}
        
        serverSvarLabel.text = "\(antalMinutter) minutter"
        
        //Definerer hvor lang tid der skal gå før vi vil se en notifikation
        let minutterTilNotifikation = 1
        //Vi vil vire rest tiden
        let restTidTilMadErKlar = antalMinutter - minutterTilNotifikation
        //Skal omregnes til sekunder
        let sekunderTilNotifikation = TimeInterval(minutterTilNotifikation * 60)
        visNotifikationEfter(sekunder: sekunderTilNotifikation, minutterTilMad: restTidTilMadErKlar) //Kalder notifikationen
    }
    
    //Func der bestiller en notifikation
    func visNotifikationEfter(sekunder : TimeInterval, minutterTilMad minutter : Int) {
        
        //Tjekker om vi må sende en notifikation
        UNUserNotificationCenter.current().getNotificationSettings { (notifikationsIndstillinger) in
            
            //Først kontrollere vi lige om notifikationer er slået til
            guard notifikationsIndstillinger.authorizationStatus == .authorized else {return}
            
            //Må vi sende alerts som notifikationer (den besked som er på låseskærmen)
            guard notifikationsIndstillinger.alertSetting == .enabled else {return}
            
            //Så laver vi notifikationen
            let indhold = UNMutableNotificationContent()
            indhold.title = "Er du sulten?"
            indhold.subtitle = "Din mad er klar"
            indhold.body = "Om \(minutter) minutter"
            
            //Hvis vi må spille lys, så spiller vi en lys
            if notifikationsIndstillinger.soundSetting == .enabled {
                indhold.sound = UNNotificationSound.default //Std lyden for notifikationer
            }
            
            //Noget der udløser notifikationen
            let udløser = UNTimeIntervalNotificationTrigger(timeInterval: sekunder, repeats: false)
            
            //Request objekt til at samle det hele
            //Jeg laver en id til vores notifikation
            let notifikationsId = "dk.dennis" + String(Date().timeIntervalSince1970) //Skal være unik hvis man vil have mere en 1 notifikation sendt og vist af gangen, da de eller bare bliver overskrevet
            print("NotifikationsID: \(notifikationsId)")
            
            let request = UNNotificationRequest(identifier: notifikationsId, content: indhold, trigger: udløser)
            
            //Så tilføjer jeg requestet til notifikations center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let fejl = error {
                    print("Fejl ved tilføjelse af notifikation")
                    print(fejl.localizedDescription)
                }
                else {
                    print("Notifikation bestilt")
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
