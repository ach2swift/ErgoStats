//
//  AgeUsdView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 17.02.2023.
//

import SwiftUI

struct AgeUsdView: View {
    @ObservedObject var vm: AgeUSDViewModel
    
    let gradient = Gradient(colors: [ .orange,  .orange, .green, .orange, .orange])
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20){
                    Gauge(value: Double(vm.ageUsdInfo.reserveRatio), in: 0...1000) {
                        Text("Ratio")
                    } currentValueLabel: {
                        Text(Int(vm.ageUsdInfo.reserveRatio), format: .percent)
                    }
                    
                    .tint(gradient)
                    .gaugeStyle(.accessoryCircular)
                    .scaleEffect(2)
                    .frame(height: 200)
                    
                    AgeUsdCardView(title: "SigUSD", value: " \(vm.ageUsdInfo.sigUsdPrice.fromNanoToErgAgeUSD()) ERG/SigUSD", value2: "1 ERG =  \(vm.ageUsd ?? "") SigUSD")
                    
                    AgeUsdCardView(title: "SigRSV", value: "\(vm.ageUsdInfo.sigRsvPrice.fromNanoToErgAgeRSV()) ERG/SigRSV", value2: "1 ERG =  \(vm.ageRsv ?? "") SigRSV")
                    Spacer()
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 30,
                        pinnedViews: [],
                        content: {
                            Text("SigUSD").bold().foregroundColor(.orange)
                            Text("Reserve Ratio").bold().foregroundColor(.orange)
                            Text("SigRSV").bold().foregroundColor(.orange)
                            Label("Purchase", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Text("Above")
                            Label("Purchase", systemImage: "x.circle.fill").foregroundColor(.red)
                            Label("Redeem  ", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Text("800%")
                            Label("Redeem  ", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                        })
                    Divider()
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 30,
                        pinnedViews: [],
                        content: {
                            Label("Purchase", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Text("800% ->")
                            Label("Purchase", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Label("Redeem  ", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Text("<- 400%")
                            Label("Redeem  ", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                        })
                    Divider()
                    LazyVGrid(
                        columns: columns,
                        alignment: .center,
                        spacing: 30,
                        pinnedViews: [],
                        content: {
                            Label("Purchase", systemImage: "x.circle.fill").foregroundColor(.red)
                            Text("Below")
                            Label("Purchase", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Label("Redeem  ", systemImage: "checkmark.circle.fill").foregroundColor(.green)
                            Text("400%")
                            Label("Redeem  ", systemImage: "x.circle.fill").foregroundColor(.red)
                        })
                }.padding(20)
            }.navigationTitle("AgeUSD")
                .refreshable {
                    vm.refresh()
                }
        }
    }
}

struct AgeUsdView_Previews: PreviewProvider {
    static var previews: some View {
        AgeUsdView(vm: AgeUSDViewModel())
    }
}
