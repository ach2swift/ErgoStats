//
//  RichListViewModel.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import Foundation

@MainActor class RichListViewModel: ObservableObject {
    @Published var richList = [RichList]()
    @Published private var _isLoadingRich: Bool = false
    
    var isLoadingRich: Bool {
        get { return _isLoadingRich }
    }
    
    func fetchRichList() async {
        if self.richList.isEmpty {
            DispatchQueue.main.async {
                self._isLoadingRich = true
            }
            
            let urlString = "https://api.ergo.watch/lists/addresses/by/balance?limit=100"
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    self._isLoadingRich = false
                }
                self.richList.removeAll()
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode([RichList].self, from: data)
                
                DispatchQueue.main.async {
                    self.richList = result
                    self._isLoadingRich = false
                }
            } catch {
                DispatchQueue.main.async {
                    self._isLoadingRich = false
                }
            }
        }
    }
    
}
