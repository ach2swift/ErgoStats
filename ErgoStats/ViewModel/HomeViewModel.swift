//
//  HomeViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import Foundation


@MainActor class HomeViewModel: ObservableObject {
    @Published var coinPrices = PriceChartModel.example
    @Published var coinData = [CoinGData]()
    
    @Published private var _isLoadingCG: Bool = false
    
    var isLoadingCG: Bool {
        get { return _isLoadingCG }
    }
    
    
    func fetchCoinMarketData() async {
        DispatchQueue.main.async {
            self._isLoadingCG = true
        }
        
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=ergo&order=market_cap_desc&per_page=10&page=1&sparkline=true&price_change_percentage=24h"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self._isLoadingCG = false
            }
            print("url string error")
            self.coinData.removeAll()
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                print("issue")
                return
            }
            let result = try JSONDecoder().decode([CoinGData].self, from: data)
            
            DispatchQueue.main.async {
                self.coinData = result
                self._isLoadingCG = false
            }
        } catch {
            print("decode error")
            DispatchQueue.main.async {
                self._isLoadingCG = false
            }
        }
    }
    
    func fetchCoinPrices() async {
        
        let urlString = "https://api.coingecko.com/api/v3/coins/ergo/market_chart?vs_currency=usd&days=30&interval=daily"
        guard let url = URL(string: urlString) else {
            print("url string error")
            self.coinPrices = PriceChartModel.example
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                print("issue")
                return
            }
            let result = try JSONDecoder().decode(PriceChartModel.self, from: data)
            
            DispatchQueue.main.async {
                self.coinPrices = result
            }
        } catch {
            print("decode error")
        }
    }
}
