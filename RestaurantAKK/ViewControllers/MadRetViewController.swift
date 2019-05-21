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
        //Tilføjer madretten til den delte resource
        RestaurantController.shared.aktuelOrdre.tilføjMadRet(madRet: parmMadRet)
    }
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        print(self.restorationIdentifier ?? "NIELS")
    }
    
    
    func updateUI() {
        //Vi beskytter os mod at view did load kaldes før restore state, ved at hoppe ud hvis parameter ikke er sat
        guard let _ = parmMadRet else {return}
        
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

    //MARK: SAVE STATE
    //Formaål med enum er at have ET sted hvor vi retter state id navne
    enum Keys: String {
        case retNummer = "madretNummer"
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        //Her skal vi gemme det data der skal til for at vores viewController kan starte op fra gemt tilstand
        coder.encode(parmMadRet.retNummer, forKey: Keys.retNummer.rawValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        //vi pakker den gemte id ud
        let retNummer = Int(coder.decodeInt32(forKey: Keys.retNummer.rawValue))
        
        //slå  retten op i vores gemte data
        if let madRet = RestaurantController.shared.stateController.madRet(medId: retNummer) {
            parmMadRet = madRet
            updateUI()
        }
    }
}
