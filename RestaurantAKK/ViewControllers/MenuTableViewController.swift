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

        //Teste om vores parameter virker
        print("Overført parameter kategorri = \(parmKategori)")
        //Sætter titlen
        self.title = parmKategori.capitalized
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Netværksindikator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.hentMenuKort(kategori: parmKategori) { (madRetter) in
            if let hentetMenu = madRetter {
                self.updateUI(med: hentetMenu)
            }
        }
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
        
//        cell.textLabel?.text = madRet.navn
//        //cell.detailTextLabel?.text = String(madRet.pris)
//        cell.detailTextLabel?.text = String(format: "Kr: %.2f", madRet.pris)
//        
//        //Henter billede
//        RestaurantController.shared.hentBillede(fraUrl: madRet.billedUrl) { (hentetBillede) in
//            
//            DispatchQueue.main.async {
//                
//                //Fordi at det kører i en tråd for sig selv, så kan vi rucikere at vi er kørt forbi den celle vi skulle have hentet billedet til. Så vi kontorllere at vi står på den rigtige indexPath, det har ingen betydning som appen er nu, da vi kører med en lokal server.
//                if let aktueltIndexPath = self.tableView.indexPath(for: cell) {
//                    if aktueltIndexPath != indexPath {
//                        return
//                    }
//                }
//                
//                cell.imageView?.image = hentetBillede
//            }
//        }
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    

}
