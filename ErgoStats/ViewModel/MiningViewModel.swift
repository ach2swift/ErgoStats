//
//  MiningViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 15.02.2023.
//

import Foundation

@MainActor class MiningViewModel: ObservableObject {
    @Published var miners = [MiningItem]()
    @Published var error: Error?
    
    let savePath = FileManager.documentDirectory.appendingPathComponent("MINING")

    
    init() {
        loadData()
    }
    
    @MainActor
    func fetchAddresses() async throws {
        do {
            let fr = Date().unixTimestampOneMonthago
            let to = Date().unixTimestampInMilliseconds
            
            let urlString = "https://api.ergo.watch/metrics/addresses/miners?fr=" + String(fr) + "&to=" + String(to) + "&r=24h&ergusd=false"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(Contracts.self, from: data) else { throw FetchError.invalidData }
            
            for index in result.timestamps.indices {
                self.miners.append(
                    .init(date: result.timestamps[index].toDateFromUnixTimestamp(), ge1: result.ge_1[index])
                )
            }
            save()

        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePath)
                miners = try JSONDecoder().decode([MiningItem].self, from: data)
            } catch {
                miners = []
                print("Unable to decode JSON")
            }
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(miners)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func loadData() {
        Task {
            try await fetchAddresses()
        }
    }
}
