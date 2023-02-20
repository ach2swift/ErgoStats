//
//  StatisticView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 4){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.percentageChange.toStringPerc())
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.green : Color.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
        
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: StatisticsModel(title: "Market Cap", value: "12.11", percentageChange: 25.34))
    }
}
