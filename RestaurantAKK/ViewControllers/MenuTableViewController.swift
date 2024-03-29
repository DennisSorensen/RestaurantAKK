//
//  MenuTableViewController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, MenuKortDelegate {

    //Parameter til viewControlleren
    var parmKategori : String! //Fordi vi har en kategori, så forceunwrapper jeg den med det samme
    //Model til datasource
    var madRetter = [MadRet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hvis der er noget i parm kategori, så ved jeg vi er kaldt fra en segue i view did load
        //Hvis ikke så er der tale om at vi er i restore state tilstand, for så sættes parm kategori senere
        if let _ = parmKategori {
            hentRetterFraServer()
        }
        
        updateUI()
    }
    
    func hentRetterFraServer() {
        //Netværksindikator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.hentMenuKort(kategori: parmKategori) { (madRetter) in
            if let hentetMenu = madRetter {
                self.updateUI(med: hentetMenu)
            }
        }
    }
    
    func updateUI() {
        guard let _ = parmKategori else {return}
        
        //Sætter titlen
        self.title = parmKategori.capitalized
    }

    func updateUI(med madRetter: [MadRet]) {
        //Er på main queue, når man opdatere ui
        DispatchQueue.main.async {
            self.madRetter = madRetter
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return madRetter.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "menuKortCelle", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuKortCelle", for: indexPath) as! MadRetTableViewCell
        
        // Configure the cell...
        let madRet = madRetter[indexPath.row]
        
        cell.madRetNavnLabel.text = madRet.navn
        cell.prisLabel.text = String(format: "Kr: %.2f", madRet.pris)
        
        return cell
    }
    
    //Pga. billedet bliver pludseligt større, men denne modvirker dette, da vi sætter højden for cellen
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    //denne func kaldes hver gang en celle skal tegnes
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? MadRetTableViewCell else {return}
        
        RestaurantController.shared.hentBillede(fraUrl: madRetter[indexPath.row].billedUrl, medForsinkelse: true) { (billede) in
            
            DispatchQueue.main.async {
                cell.opdaterBillede(medBillede: billede)
            }
        }
    }
    

    //MARK: Delegate
    
    func startForfra() {
        print("Vi skal start forfra")
        
        performSegue(withIdentifier: "startForfraSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "VisMadRetSegue" {
            
            //Sikre at vi har fat i den rigtige menu view controller
            guard let valgtRetViewController = segue.destination as? MadRetViewController else {
                print("Vi forventede en MadRetViewController ved segue")
                return
            }
            
            //Finder madretten fra vores model
            valgtRetViewController.parmMadRet = madRetter[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    //MARK: STATE HANDLING
    //Formaål med enum er at have ET sted hvor vi retter state id navne
    enum Keys: String {
        case madKategori = "madKategori"
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        //Her skal vi gemme det data der skal til for at vores viewController kan starte op fra gemt tilstand
        coder.encode(parmKategori, forKey: Keys.madKategori.rawValue)
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        //Så decoder jeg kategorien
        if let kategori = coder.decodeObject(forKey: Keys.madKategori.rawValue) as? String {
            
            //Så sætter vi parameter variablen, somom jeg var kaldt med en segue
            parmKategori = kategori
            
            //Vi skal opdatere ui
            if let madRetter = RestaurantController.shared.stateController.madRetter(forKategori: kategori) {
                self.updateUI(med: madRetter)
            }
        }
    }

}
