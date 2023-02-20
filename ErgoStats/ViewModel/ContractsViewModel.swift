//
//  ContractsViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 15.02.2023.
//

import Foundation

@MainActor class ContractsViewModel: ObservableObject {
    @Published var contracts = [ContractsItem]()
    @Published var error: Error?
    
    init() {
        loadData()
    }
    
    @MainActor
    func fetchAddresses() async throws {
        do {
            let fr = Date().unixTimestampOneMonthago
            let to = Date().unixTimestampInMilliseconds
            
            let urlString = "https://api.ergo.watch/metrics/addresses/contracts?fr=" + String(fr) + "&to=" + String(to) + "&r=24h&ergusd=false"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(Contracts.self, from: data) else { throw FetchError.invalidData }
            
            for index in result.timestamps.indices {
                self.contracts.append(
                    .init(date: result.timestamps[index].toDateFromUnixTimestamp(), ge1: result.ge_1[index])
                )
            }
        } catch {
            self.error = error
        }
    }
    
    func loadData() {
        Task {
            try await fetchAddresses()
        }
    }
}
