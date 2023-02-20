//
//  DistributionP2PK.swift
//  ErgoStats
//
//  Created by Alin Chitas on 16.02.2023.
//

import SwiftUI

struct DistributionP2PK: View {
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
                    ForEach(vm.summarySupplyP2pk.relative) { sum in
                        Text("\(sum.label.formatTopString().capitalized)").foregroundColor(.orange)
                        Text("\(String(format: "%.2f", sum.current * 100))%")
                        Text("\(String(format: "%.2f", sum.diff1D * 100))%")
                        Text("\(String(format: "%.2f", sum.diff4W * 100))%")
                        Text("\(String(format: "%.2f", sum.diff1Y * 100))%")
                    }
                })
            Divider()
                Text("ERG supply in top x wallet (P2PK) addresses. Excludes contract addresses and known main exchange addresses.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
        }
    }
}

struct DistributionP2PK_Previews: PreviewProvider {
    static var previews: some View {
        DistributionP2PK()
    }
}
