//
//  RestaurantStateController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 21/05/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import Foundation

//Definer en controller der styrer alt omkring state saving, alt det data der skal gemmes ved state
class RestaurantStateController {
    
    //Hvis jeg står med en ret id (retnummer), så skal jeg kunne slå retten op med et id
    private var retterMedID = [Int: MadRet]()
    
    //Til vores menukort skal jeg også have en struktur
    private var retterMedKategori = [String: [MadRet]]()
    
    //Opslagsmetode til at finde en ret ud fra et retnummer
    func madRet(medId retId: Int) -> MadRet? {
        return retterMedID[retId]
    }
    
    //Opslagsmetode til at finde alle retter ud fra en given kategori, det skal bruges når vi skal vise menukortet
    func madRetter(forKategori kategori: String) -> [MadRet]? {
        return retterMedKategori[kategori]
    }
    
    //Opdater index over madrteers id (som skal bruges når vi henter state fra der hvor vi bestiller)
    private func opdaterMadRetIdIndex() {
        //Giv mig et array over alle medretter for alle kategorier
        let madRetter = retterMedKategori.flatMap { $0.value } //Giver alle medretter i min dict
        
        //Jeg løber arrayet i gennem over madretter
        for madRet in madRetter {
            retterMedID[madRet.retNummer] = madRet
        }
    }
    
    //Metode der sørger for at opdatere vores lokale index for en give nkategori, hver gang vi får svar fra serveren kalder vi denne metode
    func opdater(kategori: String, medMadretter madRetter: [MadRet]?) {
        
        //Har vi kategorier gemt i forvejen
        if let _ = self.madRetter(forKategori: kategori) {
            retterMedKategori.removeValue(forKey: kategori)
        }
        //her har vi fjernet data, hvis det var der i forvejen og så gemmer vi nyt data
        if let _ = madRetter {
            retterMedKategori[kategori] = madRetter
            
            //Husk at kalde funktion til opdatering af retter med id
            self.opdaterMadRetIdIndex()
        }
        
        print("StateController opdateret")
        print(retterMedKategori)
    }
    
    //URL til state variabel
    static var fileURL : URL {
        //URL til brugeren dokumenter
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let ordreFilUrl = documentURL.appendingPathComponent("kategorier").appendingPathExtension("json")
        return ordreFilUrl
    }
    
    //MARK: state til gem og load
    func restoreState() {
        guard let kategoriData = try? Data(contentsOf: RestaurantStateController.fileURL) else {return}
        
        if let hentetKategorier = try? JSONDecoder().decode([String:[MadRet]].self, from: kategoriData) {
            retterMedKategori = hentetKategorier
            self.opdaterMadRetIdIndex()
            print("KategoriRetter fil er indlæst")
        }
    }
    
    func saveState() {
        if let kategoriData = try? JSONEncoder().encode(retterMedKategori) {
            try? kategoriData.write(to: RestaurantStateController.fileURL)
            print("kategorier er gemt")
        }
    }
}
