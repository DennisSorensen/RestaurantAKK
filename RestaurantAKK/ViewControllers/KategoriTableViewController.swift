//
//  KategoriTableViewController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 22/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class KategoriTableViewController: UITableViewController {

    //Modeller og variabler
    var madRetKategorier = [String]()
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Tænd for netværk indikator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.hentKateggorier { (kategorier) in
            if let retKategorier = kategorier {
                self.updateUI(med: retKategorier)
            }
            else {
                //Alert til brugeren
                let alert = UIAlertController(title: "Server problemer", message: "Server svarer ikke, har du husket at starte den", preferredStyle: .alert)
                
                //knapper til alert
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                //Viser action til brugeren
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func updateUI(med madRetKategorier: [String]) {
        //Er på main queue, når man opdatere ui
        DispatchQueue.main.async {
            self.madRetKategorier = madRetKategorier
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
        return madRetKategorier.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MadRetKategoriCelle", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = madRetKategorier[indexPath.row]

        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "VisMenuSegue" {
            
            //Sikre at vi har fat i den rigtige menu view controller
            guard let menuKortViewController = segue.destination as? MenuTableViewController else {
                print("Vi forventede en MenuTableViewController ved segue")
                return
            }
            
            //Finder kategorienfra vores model
            menuKortViewController.parmKategori = madRetKategorier[tableView.indexPathForSelectedRow!.row]
        }
    }
 
    @IBAction func unwindToMenuKortStart(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
