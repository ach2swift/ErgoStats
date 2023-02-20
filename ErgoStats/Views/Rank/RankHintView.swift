//
//  RankHintView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 10.02.2023.
//

import SwiftUI

struct RankHintView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange.gradient)
                .frame(width: 300, height: 500)
            VStack {
                Image(systemName: "sum")
                    .font(.largeTitle)
                VStack(alignment: .leading, spacing: 16){
                    Image(systemName: "info.circle")
                    Text("Paste your ERGO wallet receiving address in the textfield below. ")
                    Text("Make sure the address starts with '9' and has 51 characters.")
                }.padding(20)
            }.frame(width: 280, height: 500)
        }
    }
}

struct RankHintView_Previews: PreviewProvider {
    static var previews: some View {
        RankHintView()
    }
}
