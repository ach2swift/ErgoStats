//
//  AddressesViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 14.02.2023.
//

import Foundation

@MainActor class AddressesViewModel: ObservableObject {
    @Published var addresses = [AddressesItem]()
    @Published var error: Error?
    
    let savePath = FileManager.documentDirectory.appendingPathComponent("ADDRESSES")
    
    
    init() {
        loadData()
    }
    
    @MainActor
    func fetchAddresses() async throws {
        do {
            let fr = Date().unixTimestampOneMonthago
            let to = Date().unixTimestampInMilliseconds
            
            let urlString = "https://api.ergo.watch/metrics/addresses/p2pk?fr=" + String(fr) + "&to=" + String(to) + "&r=24h&ergusd=false"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(Addresses.self, from: data) else { throw FetchError.invalidData }
            
            for index in result.timestamps.indices {
                self.addresses.append(
                    .init(date: result.timestamps[index].toDateFromUnixTimestamp(), ge1: result.ge_1[index])
                )
            }
            save()
        } catch {
            self.error = error
            do {
                let data = try Data(contentsOf: savePath)
                addresses = try JSONDecoder().decode([AddressesItem].self, from: data)
            } catch {
                addresses = []
                print("Unable to decode JSON")
            }
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(addresses)
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
