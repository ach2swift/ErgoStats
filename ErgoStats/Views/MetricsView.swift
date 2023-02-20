//
//  MetricsView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var vm: MetricsViewModel
    @StateObject var vmVolume = VolumeViewModel()
    @StateObject var vmTrans = TransactionsViewModel()
    @StateObject var vmUTXO = UTXOViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    Text("Addresses")
                        .font(.title2)
                        .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(alignment: .leading){
                            HStack(spacing: 16){
                                NavigationLink(destination: P2PKView()){
                                    MetricsCardView(title: "P2PK's", value: "Total: \(vm.totalP2PK)")
                                }
                                NavigationLink(destination: ContractsView()){
                                    MetricsCardView(title: "Contracts", value: "Total: \(vm.contracts)")
                                }
                                NavigationLink(destination: MinersView()){
                                    MetricsCardView(title: "Mining Contracts", value: "Total: \(vm.miningContracts)")
                                }
                            }
                        }.offset(CGSize(width: 16, height: 0))
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 14)
                
                HStack(alignment: .center) {
                    EmmisionView(supplyDouble: vm.supplyDouble ?? 0.0)
                    VStack {
                        Text("Max Supply:")
                            .foregroundColor(.secondary)
                        Text("\(vm.totalSupply, specifier: "%.0f") ERG")
                            .padding(.bottom, 16)
                        Text("Circulating:")
                            .foregroundColor(.secondary)
                        Text("\(vm.supplyDouble ?? 0.0, specifier: "%.0f") ERG")
                    }
                }
                VStack(alignment: .leading) {
                    Text("Supply Distribution")
                        .font(.title2)
                        .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(alignment: .leading){
                            HStack(spacing: 16){
                                NavigationLink(destination: DistributionP2PK()){
                                    MetricsCardView(title: "P2PK's", value: "Top 1%:  \(vm.summarySupplyP2pkProc)")
                                }
                                NavigationLink(destination: DistributionContractsView()){
                                    MetricsCardView(title: "Contracts", value: "Top 1%:  \(vm.summarySupplyContrProc)")
                                }
                            }
                        }.offset(CGSize(width: 16, height: 0))
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 14)
                
                VStack(alignment: .leading) {
                    Text("Usage")
                        .font(.title2)
                        .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(alignment: .leading){
                            HStack(spacing: 16){
                                NavigationLink(destination: VolumeView(vm: vmVolume)){
                                    MetricsCardView(title: "Transfer Volume", value: "\( vm.transferVolume)")
                                }
                                NavigationLink(destination: TransactionsView(vm: vmTrans)){
                                    MetricsCardView(title: "Transactions", value: "\(vm.transactions)")
                                }
                                NavigationLink(destination: UtxosView(vm: vmUTXO)){
                                    MetricsCardView(title: "UTXO's", value: "\(vm.utxos)")
                                }
                            }
                        }.offset(CGSize(width: 16, height: 0))
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 14)
                
            }
            .navigationTitle("Metrics")
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}

