//
//  MetricsViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import Foundation
import SwiftUI

@MainActor class MetricsViewModel: ObservableObject {
    @Published var supply = ""
    
    @Published var summaryP2pk = [SummaryAddresses]()
    @Published var summaryContracts = [SummaryAddresses]()
    @Published var summaryMiners = [SummaryAddresses]()
    
    @Published var summaryTransaction = [SummaryUsage]()
    @Published var summaryVolume = [SummaryUsage]()
    @Published var summaryUTXO = [SummaryUsage]()
        
    @Published var summarySupplyP2pk = SupplyDistribution(absolute: [], relative: [])
    @Published var summarySupplyP2pkProc = "0.00"
    
    @Published var summarySupplyContracts = SupplyDistribution(absolute: [], relative: [])
    @Published var summarySupplyContrProc = "0.00"
    
    @Published var totalP2PK = "n/a"
    @Published var contracts = "n/a"
    @Published var miningContracts = "n/a"
    
    @Published var transferVolume = "n/a"
    @Published var transactions = "n/a"
    @Published var utxos = "n/a"
    
    @Published var error: Error?
    let totalSupply: Double = 97739925   // Total capped supply from Ergo Platform
    
    var percentMined: String {
        if let supplyDouble = supplyDouble {
            
            let per = ( supplyDouble / totalSupply ) * 100
            return String(format: "%.1f", per)
        }
        return ""
    }
    
    var supplyDouble: Double? {
        Double(supply)
    }
    
    init() {
            loadData()
    }
}

extension MetricsViewModel {
    @MainActor
    func loadData() {
        Task {
            try await fetchSummaryUTXO()
            try await fetchSummaryVolume()
            try await fetchSummaryTransactions()
            try await fetchSummaryMiners()
            try await fetchSummaryContracts()
            try await fetchSummaryP2pk()
            try await fetchSupply()
            try await fetchSupplDistr()
            try await fetchSupplDistrContracts()
        }
    }
    
    @MainActor
    func fetchSupplDistrContracts() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/supply/distribution/contracts"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(SupplyDistribution.self, from: data) else { throw FetchError.invalidData }
            
            self.summarySupplyContracts = result
            self.summarySupplyContrProc = String(format: "%.2f", result.relative[0].current * 100 )
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSupplDistr() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/supply/distribution/p2pk"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(SupplyDistribution.self, from: data) else { throw FetchError.invalidData }
            
            self.summarySupplyP2pk = result
            self.summarySupplyP2pkProc = String(format: "%.2f", result.relative[0].current * 100 )
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSummaryUTXO() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/utxos"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode([SummaryUsage].self, from: data) else { throw FetchError.invalidData }
            await MainActor.run {
                self.summaryUTXO = result
                self.utxos = result[0].current.abbreviated()
            }
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSummaryVolume() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/volume"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode([SummaryUsage].self, from: data) else { throw FetchError.invalidData }
            
            self.summaryVolume = result
            self.transferVolume = Int(result[0].current / 1_000_000_000).abbreviated()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSummaryTransactions() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/transactions"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode([SummaryUsage].self, from: data) else { throw FetchError.invalidData }
            
            self.summaryTransaction = result
            self.transactions = result[0].current.abbreviated()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSummaryMiners() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/addresses/miners"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode([SummaryAddresses].self, from: data) else { throw FetchError.invalidData }
            
            self.summaryMiners = result
            self.miningContracts = result[0].current.abbreviated()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSummaryContracts() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/addresses/contracts"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode([SummaryAddresses].self, from: data) else { throw FetchError.invalidData }
            
            self.summaryContracts = result
            self.contracts = result[0].current.abbreviated()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func fetchSummaryP2pk() async throws {
        do {
            let urlString = "https://api.ergo.watch/metrics/summary/addresses/p2pk"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode([SummaryAddresses].self, from: data) else { throw FetchError.invalidData }
            
            await MainActor.run {
                self.summaryP2pk = result
                self.totalP2PK = result[0].current.abbreviated()
            }
            
        } catch {
            self.error = error
        }
    }
    
    
    @MainActor
    func fetchSupply() async throws {
        do {
            let urlString = "https://api.ergoplatform.com/api/v0/info/supply"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            let result = String(decoding: data, as: UTF8.self)
            //guard let result = try? JSONDecoder().decode(String.self, from: data) else { throw FetchError.invalidData }
            
            self.supply = result
        } catch {
            self.error = error
        }
    }

}


