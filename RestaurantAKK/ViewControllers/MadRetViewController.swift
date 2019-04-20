//
//  MadRetViewController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class MadRetViewController: UIViewController, MenuKortDelegate {

    var parmMadRet : MadRet!
    
    //MARK: Outlets og actions
    @IBOutlet weak var bestilKnap: BestilKnap!
    @IBOutlet weak var madRetBillede: UIImageView!
    @IBOutlet weak var madRetTitel: UILabel!
    @IBOutlet weak var madRetPrisLabel: UILabel!
    @IBOutlet weak var madRetBeskrivelse: UILabel!
    
    @IBAction func bestilKnapKlikket(_ sender: BestilKnap) {
        sender.klikAnimation()
//        //Gemmer vores madret i vores globale variabel
//        let applikation = UIApplication.shared.delegate as! AppDelegate //Får vores appDelegate, hvor vores variabel ligger i. og jeg forceunwrapper pga. vores app kan slet ikke køre uden denne fil
//        applikation.aktuelBestilling.append(parmMadRet)
    }
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Overført værdi: \(parmMadRet.navn)")
        
        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    
    func updateUI() {
        madRetTitel.text = parmMadRet.navn
        madRetPrisLabel.text = String(format: "Kr: %.2f", parmMadRet.pris)
        madRetBeskrivelse.text = parmMadRet.beskrivelse
        
        //Henter billede
        RestaurantController.shared.hentBillede(fraUrl: parmMadRet.billedUrl) { (hentetBillede) in
            
            guard let billede = hentetBillede else {return}
            
            DispatchQueue.main.async {
                self.madRetBillede.image = billede
            }
        }
    }

    //MARK: Delegate
    
    func startForfra() {
        print("Vi skal start forfra")
        
        performSegue(withIdentifier: "startForfraSegue", sender: nil)
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
