//
//  HomeView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import SwiftUI
import Charts

enum NavigationType: String, Hashable {
    case about = "ABOUT"
    case home = "HOME"
}

struct HomeView: View {
    @State private var mainStack: [NavigationType] = []
    @EnvironmentObject var vm: HomeViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private var spacing: CGFloat = 30
    
    
    var body: some View {
        NavigationStack(path: $mainStack) {
            ScrollView(showsIndicators: false){
                VStack(spacing: 20){
                        Chart {
                            ForEach(vm.coinPrices.prices, id: \.self) {
                                LineMark(
                                    x: .value("Date", Date(miliseconds: Int64($0[0]))),
                                    y: .value("Price", $0[1])
                                )
                            }
                        }
                        .chartYScale(domain: .automatic(includesZero: false))
                        .frame(height: 250)
                        .padding()
                    Label("price last 30 days", systemImage: "sum")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Text("Summary")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    LazyVGrid(
                        columns: columns,
                        alignment: .leading,
                        spacing: spacing,
                        pinnedViews: [],
                        content: {
                            ForEach(vm.coinData) { coin in
                                StatisticView(stat: StatisticsModel(title: "Market Cap", value: coin.marketCap?.asCurrencyWith6Decimals() ?? "", percentageChange: coin.marketCapChangePercentage24H))
                                StatisticView(stat: StatisticsModel(title: "Current price", value: coin.currentPrice?.asCurrencyWith6Decimals() ?? "", percentageChange: coin.priceChangePercentage24H))
                                StatisticView(stat: StatisticsModel(title: "Total volume", value: coin.totalVolume?.asCurrencyWith6Decimals() ?? ""))
                                StatisticView(stat: StatisticsModel(title: "Market Cap Rank", value: coin.marketCapRank.toPlainString() ))
                                StatisticView(stat: StatisticsModel(title: "Low 24h", value: coin.low24H.toPlainString2F() ))
                                StatisticView(stat: StatisticsModel(title: "High 24h", value: coin.high24H.toPlainString2F() ))
                            }
                        })
                }
                .navigationTitle("ergo stats")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            mainStack.append(.about)
                        }label: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                Task {
                    await vm.fetchCoinMarketData()
                }
            }
            .navigationDestination(for: NavigationType.self) { value in
                switch value {
                case .about:
                    AboutView()
                    
                case .home: HomeView()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
