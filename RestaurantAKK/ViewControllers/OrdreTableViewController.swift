//
//  OrdreTableViewController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class OrdreTableViewController: UITableViewController, TjenerDelegate {
    
    //Model til datasource
    var madRetter = [MadRet]()
    //delt variabel, der indeholder leveringstid svar vi går fra serveren
    var leveringsMinutter : Int?
    //Delegate til menuKortDelegate
    var menuKortDelegate : MenuKortDelegate?
    
    //Knap til at bestille maden med
    @IBAction func bestilKnapTrykket(_ sender: UIBarButtonItem) {
        
        //Hvad er min ordre total
        let ordreTotal = madRetter.reduce(0.0) { (subtotal, madRet) -> Double in
            return subtotal + madRet.pris
        }
        let samletKoebTekst = String(format: "Kr: %.2f", ordreTotal) //Formaterer int med kr på
        print("Totalen er \(samletKoebTekst)")
        
        //Alert til brugeren, om de vil køre det som er i listen
        let alert = UIAlertController(title: "Bekræft din bestilling", message: "Er du sikker på at du vil bestille mad for \(samletKoebTekst)", preferredStyle: .alert)
        
        //knapper til alert
        let jaAction = UIAlertAction(title: "Ja", style: .default) { (action) in
            self.bestilMaden()
        }
        alert.addAction(jaAction)
        
        let nejAction = UIAlertAction(title: "Nej", style: .cancel, handler: nil)
        alert.addAction(nejAction)
        
        //Viser action til brugeren
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let applikation = UIApplication.shared.delegate as! AppDelegate //Får vores appDelegate, hvor vores variabel ligger i. og jeg forceunwrapper pga. vores app kan slet ikke køre uden denne fil
        print(applikation.aktuelBestilling)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //funktion til at bestille maden
    func bestilMaden() {
        //TODO: Kod logikken til at bestille maden
        print("Nu bestiller vi maden")
        
        let madRetNumre = madRetter.map { $0.retNummer } //For hver madret returnerer jeg retnumret
        
        print(madRetNumre)
        
        RestaurantController.shared.sendBestilling(valgteRetNumre: madRetNumre) { (svarMinutter) in
            //Sørge for at sende aver ud på hovedtråden
            DispatchQueue.main.async {
                if let minutter = svarMinutter {
                    print("Der går \(minutter)")
                    self.leveringsMinutter = minutter //Sætter vores delt variabel
                    //Kalde vores segue
                    self.performSegue(withIdentifier: "ordreBekræftSegue", sender: nil)
                }
            }
        }
        
        
    }
    
    func opdaterBadge() {
        let badgeTekst = madRetter.count > 0 ? "\(madRetter.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeTekst
    }
    
    //MARK: Delegate
    
    func madRetTilOrdren(madRet: MadRet) {
        //Tilføjer madretten til ordren som vi har fået fra kunden
        madRetter.append(madRet)
        //Tilføjer madretten til table view
        let placering = IndexPath(row: madRetter.count - 1, section: 0)
        tableView.insertRows(at: [placering], with: .automatic)
        
        //Opdatere badgen til at vise brugeren vi har sat noget i ordren
        opdaterBadge()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordreListeCelle", for: indexPath)
        
        // Configure the cell...
        let madRet = madRetter[indexPath.row]
        
        cell.textLabel?.text = madRet.navn
        //cell.detailTextLabel?.text = String(madRet.pris)
        cell.detailTextLabel?.text = String(format: "Kr: %.2f", madRet.pris)
        
        //Henter billede
        RestaurantController.shared.hentBillede(fraUrl: madRet.billedUrl) { (hentetBillede) in
            
            DispatchQueue.main.async {
                
                //Fordi at det kører i en tråd for sig selv, så kan vi rucikere at vi er kørt forbi den celle vi skulle have hentet billedet til. Så vi kontorllere at vi står på den rigtige indexPath, det har ingen betydning som appen er nu, da vi kører med en lokal server.
                if let aktueltIndexPath = self.tableView.indexPath(for: cell) {
                    if aktueltIndexPath != indexPath {
                        return
                    }
                }
                
                cell.imageView?.image = hentetBillede
                
            }
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            madRetter.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   */
        opdaterBadge()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: Delegete
    //Funcktion til at finde vores menukort, ham som skal udføre vores opgaver vi stiller ham
    func definerMenuKortDelegate() -> MenuKortDelegate? {
        
        //Hvis nogen her defineres sig som delegste til os, så skal vi ikke finde ud af det
        if menuKortDelegate != nil {
            return menuKortDelegate
        }
        
        if let navController = tabBarController?.viewControllers?.first as? UINavigationController {
            //Nu har vi navigation controller, som er far til vores menukort view controller
            if let menuKortController = navController.viewControllers.last as? MenuKortDelegate {
                //Nu har vi vores view controller vi stod på sidst, inden vi skiftede til ordre siden
                return menuKortController //Vi gemmer ikke den delegerede da, de så kan være et forkets skærmbillede som der er den delegerede
            }
        }
        return menuKortDelegate
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ordreBekræftSegue" {
            guard let destination = segue.destination as? BestillingViewController else { return }
            
            destination.minutter = leveringsMinutter
        }
    }
    
    @IBAction func unwindToOrdreSeddel(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if unwindSegue.identifier == "bekræftetOKSegue" {
            //Så har brugeren set leverings tidspunkt og jeg kan rydde op
            //Først fydder vi data
            madRetter.removeAll()
            //Opdater view
            tableView.reloadData()
            //Opdater badge
            self.opdaterBadge()
            
            //Nulstiller menukort
            definerMenuKortDelegate()?.startForfra()
        }
    }
}
