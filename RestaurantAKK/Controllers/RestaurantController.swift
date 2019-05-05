//
//  RestaurantController.swift
//  RestaurantAKK
//
//  Created by Dennis Sørensen on 27/01/2019.
//  Copyright © 2019 DennisSorensen. All rights reserved.
//

import UIKit

class RestaurantController {
    
    //Variabel til at holde den delte ordreSeddel for den aktuelle ordre
    var aktuelOrdre = OrdreSeddel() {
        didSet {
            NotificationCenter.default.post(name: RestaurantController.ordreOpdNotifikationsNavn, object: nil)
        }
    }
    
    //Vores base url til api'en
    let basisUrl = URL(string: "http://localhost:8090/")! //Force-unwrapper fordi vi er sikker på den lykkedes
    
    //Få en liste over kategorier
    public func hentKateggorier(completion: @escaping ([String]?) -> Void) {
        //Tilføjer til base url
        let kategoriURL = basisUrl.appendingPathComponent("categories")
        
        //Kalder api
        let task = URLSession.shared.dataTask(with: kategoriURL) { (data, respons, error) in
            
            if let serverSvar = data {
                let dekoder = JSONDecoder()
                
                let madRetKategorier = try? dekoder.decode(MadRetKategorier.self, from: serverSvar)
                
                completion(madRetKategorier?.kategorier)
            }
            else {
                print("Ingen kategori svar fra server")
                
                if let fejl = error {
                    print(fejl.localizedDescription)
                }
                
                if let serverRespons = respons as? HTTPURLResponse {
                    print("Server kode: \(serverRespons.statusCode)")
                }
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    
    //Hent menukort
    public func hentMenuKort(kategori: String, completion: @escaping ([MadRet]?) -> Void) {
        //Laver vores url
        let endPointUrl = basisUrl.appendingPathComponent("menu")
        //Så skal vi have noget data med
        var urlDele = URLComponents(url: endPointUrl, resolvingAgainstBaseURL: true)!
        urlDele.queryItems = [URLQueryItem(name: "category", value: kategori)]
        //Får den færdige url med parametre
        let menuKortUrl = urlDele.url!
        
        //Kalder api
        let task = URLSession.shared.dataTask(with: menuKortUrl) { (data, respons, error) in
            
            if let serverSvar = data {
                let dekoder = JSONDecoder()
                
                let madRetter = try? dekoder.decode(MadRetter.self, from: serverSvar)
                
                completion(madRetter?.madretter)
            }
            else {
                print("Ingen menu svar fra server")
                if let serverRespons = respons as? HTTPURLResponse {
                    print("Server kode: \(serverRespons.statusCode)")
                }
            }
            
        }
        task.resume()
    }
    
    
    //Post bestilling og få en ordre bekræftelse retur
    public func sendBestilling(valgteRetNumre: [Int], completion: @escaping (Int?) -> Void) {
        //Laver url
        let bestilURL = basisUrl.appendingPathComponent("order")
        
        //Ændre på http kaldet til en post
        var request = URLRequest(url: bestilURL)
        request.httpMethod = "POST"
        //Fortalt hvilket format dataene er i
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Laver vores data
        let data : [String :  [Int]] = ["menuIds" : valgteRetNumre]
        //Laver vores data om til json
        let jsonKoder = JSONEncoder()
        let jsonData = try? jsonKoder.encode(data)
        
        //Udfylde vores data i body
        request.httpBody = jsonData
        
        //Kalder api
        let task = URLSession.shared.dataTask(with: request) { (data, respons, error) in
            
            if let serverSvar = data {
                let dekoder = JSONDecoder()
                
                let brkraeftelse = try? dekoder.decode(OrdreBrkraeftelse.self, from: serverSvar)
                
                completion(brkraeftelse?.tilberedningstid)
            }
            else {
                print("Ingen ordrebrkræftelse fra server")
                if let serverRespons = respons as? HTTPURLResponse {
                    print("Server kode: \(serverRespons.statusCode)")
                }
            }
            
        }
        task.resume()
    }
    
    //Hent et givent billede ud fra en url
    public func hentBillede(fraUrl : URL, completion : @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: fraUrl) { (data, respons, error) in
            
            if let billedData = data {
                if let billede = UIImage(data: billedData) {
                    completion(billede)
                }
                else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    //Hent et givent billede ud fra en url, og venter et antal sekunder(simuleret) og kalder en completion handler
    public func hentBillede(fraUrl : URL, medForsinkelse: Bool, completion : @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: fraUrl) { (data, respons, error) in
            
            if let billedData = data {
                if let billede = UIImage(data: billedData) {
                    if medForsinkelse {
                        RestaurantController.simulerForsinkelse(forUrl: fraUrl)
                    }
                    completion(billede)
                }
                else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    //MARK: ORDREFIL
    func loadOrdre() {
        guard let ordreData = try? Data(contentsOf: OrdreSeddel.fileURL) else {return}
        
        if let hentetOrdre = try? JSONDecoder().decode(OrdreSeddel.self, from: ordreData) {
            aktuelOrdre = hentetOrdre
            print("Ordreseddel er hentet")
        }
        else {
            //Laver en tom ordreseddel
            aktuelOrdre = OrdreSeddel()
        }
    }
    
    func saveOrdre() {
        if let ordreData = try? JSONEncoder().encode(aktuelOrdre) {
            try? ordreData.write(to: OrdreSeddel.fileURL)
            print("Ordreseddel er gemt")
        }
    }
    
    //MARK: STATIC
    static let shared = RestaurantController()
    
    static func simulerForsinkelse(forUrl: URL) {
        let pauseSekunder = UInt32.random(in: 0...4)
        print("Pause i \(pauseSekunder) for \(forUrl)")
        sleep(pauseSekunder)
    }
    
    //Radionsignal navn
    static let ordreOpdNotifikationsNavn = Notification.Name("dk.eat.just.ordreOpd")
}
