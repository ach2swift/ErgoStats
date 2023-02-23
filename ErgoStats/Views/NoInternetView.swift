//
//  NoInternetView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 23.02.2023.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
            Text(verbatim: "Please check your internet connection")
        }
    }
}

struct NoInternetView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetView()
    }
}
