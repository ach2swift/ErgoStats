//
//  AboutView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 09.02.2023.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        NavigationView {
            List {
                Section("Dark / Light mode") {
                    Toggle("Dark mode enabled", isOn: $isDarkMode)
                }
                Section("API data") {
                    HStack {
                        Text("ERG price is provided by")
                        Link("CoinGecko", destination: URL(string: "https://www.coingecko.com")!)
                    }
                    HStack {
                        Text("Metrics are provided by")
                        Link("ergo.watch", destination: URL(string: "https://www.ergo.watch/metrics")!)
                    }
                    HStack {
                        Text("AgeUSD is provided by")
                        Link("tokenjay.app", destination: URL(string: "https://www.tokenjay.app")!)
                    }
                    
                }
                Section("Creator") {
                    VStack{
                        Text("Created by Alin Chitas, 2023")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 10)
                        Text("The project is open source software")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section("Contact") {
                    HStack {
                        Text("Reach out on")
                        Link("Discord", destination: URL(string: "https://www.discord.gg/ergo-platform-668903786361651200")!)
                    }
                }
                Section("Version") {
                    Text(appVersion ?? "1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
