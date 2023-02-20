//
//  EmmisionView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 08.02.2023.
//

import SwiftUI

struct EmmisionView: View {
    @EnvironmentObject var vm: MetricsViewModel
    var supplyDouble: Double
    
    var body: some View {
        ZStack {
            VStack(spacing: 22) {
                Text("Emmision")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                // .foregroundColor(.white)
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.orange.opacity(0.1), lineWidth: 10)
                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                    
                    Circle()
                        .trim(from: 0, to: supplyDouble / vm.totalSupply)
                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                    Text(vm.percentMined)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                        .rotationEffect(.init(degrees: 90))
                }
                .rotationEffect(.init(degrees: -90))
            }
            .padding()
        }
        .padding()
    }
}

struct EmmisionView_Previews: PreviewProvider {
    static var previews: some View {
        EmmisionView(supplyDouble: 70111111.11)
    }
}
