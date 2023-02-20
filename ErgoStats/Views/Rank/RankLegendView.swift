//
//  RankLegendView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 05.02.2023.
//

import SwiftUI

struct RankLegendView: View {
    let rankDescription = ["Recruit", "Second Liutenant", "First Liutenant", "Captain", "Major", "Liutenant Colonel", "Colonel", "Brigadier General", "Major General", "Liutenant General", "General" ]
    let rankBoundaries = ["0", "100", "1,000", "5,000", "15,000", "30,000", "50,000", "100,000", "250,000", "500,000", "1,000,000"]
    var body: some View {
        List {
            Section( header: HStack{ Spacer()
                                    Text("Starts at:")
                                    Image(systemName: "sum")
            }){
                ForEach(0..<11) { ind in
                    HStack {
                        Text("\(ind).")
                        if ind == 0 {
                            Image(systemName: "person").font(.system(size: 35.0))
                            Text("\(rankDescription[ind])")
                        } else {
                            Image("\(ind)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("\(rankDescription[ind])")
                        }
                        Spacer()
                        Text(rankBoundaries[ind])
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct RankLegendView_Previews: PreviewProvider {
    static var previews: some View {
        RankLegendView()
    }
}
