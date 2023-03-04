//
//  MetricsViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import Foundation
import SwiftUI

@MainActor class MetricsViewModel: ObservableObject {
    
    let savePathSDC = FileManager.documentDirectory.appendingPathComponent("SDC")
    let savePathSD = FileManager.documentDirectory.appendingPathComponent("SD")
//    let savePathSupply = FileManager.documentDirectory.appendingPathComponent("SUPPLY")
    let savePathSumP2PK = FileManager.documentDirectory.appendingPathComponent("SUMP2PK")
    let savePathSumContr = FileManager.documentDirectory.appendingPathComponent("SUMCONTR")
    let savePathSumMin = FileManager.documentDirectory.appendingPathComponent("SUMMIN")
    let savePathSumTrans = FileManager.documentDirectory.appendingPathComponent("SUMTRANS")
    let savePathSumVol = FileManager.documentDirectory.appendingPathComponent("SUMVOL")
    let savePathSumUTXO = FileManager.documentDirectory.appendingPathComponent("SUMUTXO")
    
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

    
    // Generic function to encode the array as JSON
    func save<T: Encodable>(items: [T], to path: URL) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: path, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func saveSupply(distribution: SupplyDistribution, to path: URL) {
        do {
            let data = try JSONEncoder().encode(distribution)
            try data.write(to: path, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
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
            
            saveSupply(distribution: summarySupplyContracts, to: savePathSDC)
        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSDC)
                summarySupplyContracts = try JSONDecoder().decode(SupplyDistribution.self, from: data)
                summarySupplyContrProc = String(format: "%.2f", summarySupplyContracts.relative[0].current * 100 )
            } catch {
                summarySupplyContracts = SupplyDistribution(absolute: [], relative: [])
                summarySupplyContrProc = ""
                print("Unable to decode JSON")
            }
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
            
            saveSupply(distribution: summarySupplyP2pk, to: savePathSD)
        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSD)
                summarySupplyP2pk = try JSONDecoder().decode(SupplyDistribution.self, from: data)
                summarySupplyP2pkProc = String(format: "%.2f", summarySupplyP2pk.relative[0].current * 100 )
            } catch {
                summarySupplyP2pk = SupplyDistribution(absolute: [], relative: [])
                summarySupplyP2pkProc = ""
                print("Unable to decode JSON")
            }
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
                save(items: summaryUTXO, to: savePathSumUTXO)
            }
        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSumUTXO)
                summaryUTXO = try JSONDecoder().decode([SummaryUsage].self, from: data)
                utxos = summaryUTXO[0].current.abbreviated()
            } catch {
                summaryUTXO = [SummaryUsage]()
                utxos = "n/a"
                print("Unable to decode JSON")
            }
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
            
            save(items: summaryVolume, to: savePathSumVol)

        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSumVol)
                summaryVolume = try JSONDecoder().decode([SummaryUsage].self, from: data)
                transferVolume = Int(summaryVolume[0].current / 1_000_000_000).abbreviated()
            } catch {
                summaryVolume = [SummaryUsage]()
                transferVolume = "n/a"
                print("Unable to decode JSON")
            }
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
            
            save(items: summaryTransaction, to: savePathSumTrans)

        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSumTrans)
                summaryTransaction = try JSONDecoder().decode([SummaryUsage].self, from: data)
                transactions = summaryTransaction[0].current.abbreviated()
            } catch {
                summaryTransaction = [SummaryUsage]()
                transactions = "n/a"
                print("Unable to decode JSON")
            }
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
            
            save(items: summaryMiners, to: savePathSumMin)

        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSumMin)
                summaryMiners = try JSONDecoder().decode([SummaryAddresses].self, from: data)
                miningContracts = summaryMiners[0].current.abbreviated()
            } catch {
                summaryMiners = [SummaryAddresses]()
                miningContracts = "n/a"
                print("Unable to decode JSON")
            }
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
            
            save(items: summaryContracts, to: savePathSumContr)

        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSumContr)
                summaryContracts = try JSONDecoder().decode([SummaryAddresses].self, from: data)
                contracts = summaryContracts[0].current.abbreviated()
            } catch {
                summaryContracts = [SummaryAddresses]()
                contracts = "n/a"
                print("Unable to decode JSON")
            }
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
                
                save(items: summaryP2pk, to: savePathSumP2PK)

            }
            
        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePathSumP2PK)
                summaryP2pk = try JSONDecoder().decode([SummaryAddresses].self, from: data)
                totalP2PK = summaryP2pk[0].current.abbreviated()
            } catch {
                summaryP2pk = [SummaryAddresses]()
                totalP2PK = "n/a"
                print("Unable to decode JSON")
            }
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


