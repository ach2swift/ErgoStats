//
//  TransactionsViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 14.02.2023.
//

import Foundation

@MainActor class TransactionsViewModel: ObservableObject {
    @Published var transactionItems = [TransactionItem]()
    @Published var error: Error?
    
    init() {
        loadData()
    }
    
    @MainActor
    func fetchTransactions() async throws {
        do {
            let fr = Date().unixTimestampOneMonthago
            let to = Date().unixTimestampInMilliseconds
            
            let urlString = "https://api.ergo.watch/metrics/transactions?fr=" + String(fr) + "&to=" + String(to) + "&r=24h&ergusd=false"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(Volume.self, from: data) else { throw FetchError.invalidData }
            
            for index in result.timestamps.indices {
                self.transactionItems.append(
                    .init(date: result.timestamps[index].toDateFromUnixTimestamp(), vol: result.daily1D[index])
                )
            }
        } catch {
            self.error = error
        }
    }
    
    func loadData() {
        Task {
            try await fetchTransactions()
        }
    }
}
