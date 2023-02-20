//
//  DistributionContractsView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 16.02.2023.
//

import SwiftUI

struct DistributionContractsView: View {
    @EnvironmentObject var vm: MetricsViewModel
    
    private var spacing: CGFloat = 30
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: spacing,
                pinnedViews: [],
                content: {
                    Text("Addr.").bold()
                    Text("Current").bold()
                    Text("1 Day").bold()
                    Text("4 Weeks").bold()
                    Text("1 Year").bold()
                    ForEach(vm.summarySupplyContracts.relative) { sum in
                        Text("\(sum.label.formatTopString().capitalized)").foregroundColor(.orange)
                        Text("\(String(format: "%.2f", sum.current * 100))%")
                        Text("\(String(format: "%.2f", sum.diff1D * 100))%")
                        Text("\(String(format: "%.2f", sum.diff4W * 100))%")
                        Text("\(String(format: "%.2f", sum.diff1Y * 100))%")
                    }
                })
            Divider()
            Text("ERG supply in top x contract addresses, excluding (re)emission contracts, mining contracts and the EF treasury.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

struct DistributionContractsView_Previews: PreviewProvider {
    static var previews: some View {
        DistributionContractsView()
    }
}
