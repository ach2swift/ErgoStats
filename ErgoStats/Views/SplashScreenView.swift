//
//  SplashScreenView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var network: NetworkMonitor

    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            if network.isActive {
                ContentView()
            } else {
                NoInternetView()
            } 
        } else {
            ZStack {
                VStack {
                    Rectangle()
                        .frame(width: 130, height: 30)
                        .foregroundColor(Color("orangeErgo"))
                    Rectangle()
                        .frame(width: 130, height: 30)
                        .foregroundColor(Color("orangeErgo"))
                        .padding()
                    Rectangle()
                        .frame(width: 130, height: 30)
                        .foregroundColor(Color("orangeErgo"))
                        .padding(30)
                    Text("ergo stats")
                        .font(.title)
                        .opacity(0.8)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
    }
}


struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
