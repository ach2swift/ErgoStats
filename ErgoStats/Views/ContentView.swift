//
//  ContentView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var vmAge = AgeUSDViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(vm)
                .tabItem {
                    Image(systemName: Tab.home.rawValue)
                    Text("Home")
                    
                }
                .tag(Tab.home)
            MetricsView()
                .tabItem {
                    Image(systemName: Tab.metrics.rawValue)
                    Text("Metrics")
                }
                .tag(Tab.metrics)
            RankView()
                .tabItem {
                    Image(systemName: Tab.rank.rawValue)
                    Text("Rank")
                }
                .tag(Tab.rank)
            RichListView()
                .tabItem {
                    Image(systemName: Tab.richList.rawValue)
                    Text("Rich List")
                }
                .tag(Tab.richList)
            AgeUsdView(vm: vmAge)
                .tabItem {
                    Image(systemName: Tab.stable.rawValue)
                    Text("SigUSD")
                }
                .tag(Tab.stable)
        }
            .accentColor(.orange)
            .onAppear{
                let standardAppearence = UITabBarAppearance()
                standardAppearence.configureWithOpaqueBackground()
                UITabBar.appearance().standardAppearance = standardAppearence
                
                let scrollEdgeApp = UITabBarAppearance()
                scrollEdgeApp.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = scrollEdgeApp
            }
    }
}

enum Tab: String, CaseIterable{
    case home = "house.circle"
    case metrics = "chart.line.uptrend.xyaxis.circle"
    case rank = "sum"
    case stable = "dollarsign.circle"
    case richList = "list.bullet.circle"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
