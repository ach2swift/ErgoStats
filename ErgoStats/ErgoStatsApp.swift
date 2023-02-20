//
//  ErgoStatsApp.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import SwiftUI

@main
struct ErgoStatsApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    @StateObject var vm = HomeViewModel()
    @StateObject var vmMetrics = MetricsViewModel()
    @StateObject var vmAddr = AddressesViewModel()
    @StateObject var vmContr = ContractsViewModel()
    @StateObject var vmMini = MiningViewModel()
    
    
    
    @State private var showAlert = false
    
    var body: some Scene {
            WindowGroup {
                SplashScreenView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .onReceive(vmMetrics.$error, perform: { error in
                        if error != nil {
                            showAlert.toggle()
                        }
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(vmMetrics.error?.localizedDescription ?? ""))
                    }
                    .environmentObject(vmMetrics)
                    .environmentObject(vm)
                    .environmentObject(vmAddr)
                    .environmentObject(vmContr)
                    .environmentObject(vmMini)
                    .task {
                        await vm.fetchCoinMarketData()
                        await vm.fetchCoinPrices()
                    }
            }
    }
}
