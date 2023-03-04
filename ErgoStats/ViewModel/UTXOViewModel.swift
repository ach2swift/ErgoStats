//
//  UTXOViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 14.02.2023.
//

import Foundation

@MainActor class UTXOViewModel: ObservableObject {
    @Published var utxos = [UTXOItem]()
    @Published var error: Error?
    
    let savePath = FileManager.documentDirectory.appendingPathComponent("UTXO")

    
    init() {
        loadData()
    }
    
    @MainActor
    func fetchUTXOs() async throws {
        do {
            let fr = Date().unixTimestampOneMonthago
            let to = Date().unixTimestampInMilliseconds
            
            let urlString = "https://api.ergo.watch/metrics/utxos?fr=" + String(fr) + "&to=" + String(to) + "&r=24h&ergusd=false"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(UTXOs.self, from: data) else { throw FetchError.invalidData }
            
            for index in result.timestamps.indices {
                self.utxos.append(
                    .init(date: result.timestamps[index].toDateFromUnixTimestamp(), utxo: result.values[index])
                )
            }
            save()

        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePath)
                utxos = try JSONDecoder().decode([UTXOItem].self, from: data)
            } catch {
                utxos = []
                print("Unable to decode JSON")
            }
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(utxos)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func loadData() {
        Task {
            try await fetchUTXOs()
        }
    }
}
