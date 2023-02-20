//
//  AgeUsdCardView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 17.02.2023.
//

import SwiftUI

struct AgeUsdCardView: View {
    var title: String?
    var value: String?
    var value2: String?
    
    var body: some View {
        ZStack{
            Color.orange.opacity(1)
                .frame(width: 300, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            VStack{
                Text(title ?? "")
                    .foregroundColor(.black)
                    .font(.title)
                    .lineLimit(nil)
                    .padding(.bottom, 4)
                
                Spacer()
                Text(value2 ?? "")
                    .labelStyle(.titleAndIcon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .opacity(value == nil ? 0.0 : 1.0)
                Spacer()
                Text(value ?? "")
                    .labelStyle(.titleAndIcon)
                    .font(.callout)
                    .foregroundColor(.black.opacity(0.8))
                    .opacity(value == nil ? 0.0 : 1.0)
            }
            .padding(16)
            .frame(width: 300, height: 130, alignment: .center)
        }
    }
}


struct AgeUsdCardView_Previews: PreviewProvider {
    static var previews: some View {
        AgeUsdCardView(title: "SigUSD", value: "0.5882352 ERG/SigUSD", value2: "1 ERG = 1.7 SigUSD")
    }
}
