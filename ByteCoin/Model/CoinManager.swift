//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUptadeCoin(_ coinManager: CoinManager, price: String)
    func didFailWithError(_ coinManager: CoinManager, error: Error)
        
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8CD72664-54EC-408A-8FDD-281584A96EFB"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for Currency: String) {
        
        if let url = URL(string: "\(baseURL)/\(Currency)?apikey=\(apiKey)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    self.delegate?.didFailWithError(self, error: error)
                    print("server error")
                    return
                }
                
                if let data = data {
                    if let coinRate = parseJson(data) {
                        let rateString = String(format: "%.2f", coinRate)
                        self.delegate?.didUptadeCoin(self, price: rateString)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJson(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
            
            
        } catch {
            self.delegate?.didFailWithError(self, error: error)
            print("decoding error")
            return nil
        }
        
    }

    
}
