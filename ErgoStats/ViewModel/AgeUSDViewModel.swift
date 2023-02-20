//
//  AgeUSDViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 17.02.2023.
//

import Foundation

@MainActor class AgeUSDViewModel: ObservableObject {
    @Published var ageUsdInfo = AgeUSD(reserveRatio: 0, sigUsdPrice: 0, sigRsvPrice: 0)
    @Published var error: Error?
    @Published var ageUsd: String?
    @Published var ageRsv: String?
    
    init() {
        loadData()
    }
    
    @MainActor
    func fetchAgeUsdInfo() async throws {
        do {
            let urlString = "https://api.tokenjay.app/ageusd/info"
            guard let url = URL(string: urlString) else { throw FetchError.invalidUrl }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.serverError }
            guard let result = try? JSONDecoder().decode(AgeUSD.self, from: data) else { throw FetchError.invalidData }
            ageUsdInfo = result
            ageUsd = String( format: "%.2f", 1 / result.sigUsdPrice.fromNanoToErgAgeUSD() )
            ageRsv = String( format: "%.0f", 1 / result.sigRsvPrice.fromNanoToErgAgeRSV() )
        } catch {
            self.error = error
        }
    }
    
    func loadData() {
        Task {
            try await fetchAgeUsdInfo()
        }
    }
    
    func refresh() {
        Task{
           try await fetchAgeUsdInfo()
        }
    }
}
