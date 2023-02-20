//
//  RankViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import Foundation


@MainActor class RankViewModel: ObservableObject {
    @Published var rankResult = RankResult.example

    @Published private var _isLoadingRank: Bool = false
    @Published private var _rankError: Bool = false
    
    var rankError: Bool {
        get { return _rankError }
    }
    
    var isLoadingRank: Bool {
        get { return _isLoadingRank }
    }

    
    func fetchRank(inputAddress: String) async {
        DispatchQueue.main.async {
            self._isLoadingRank = true
            self.rankResult = RankResult.example
        }
        let urlString = "https://api.ergo.watch/ranking/" + inputAddress
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self._isLoadingRank = false
                self._rankError = true
                self.rankResult = RankResult.example
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(RankResult.self, from: data)
            
            DispatchQueue.main.async {
                self.rankResult = result
                self._isLoadingRank = false
            }
        } catch {
            print("Error in fetching data")
            
            DispatchQueue.main.async {
                self._isLoadingRank = false
                self._rankError = true
            }
        }
    }
}
