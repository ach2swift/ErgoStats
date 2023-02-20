//
//  MetricsCardView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 08.02.2023.
//

import SwiftUI

struct MetricsCardView: View {
    var title: String
    var value: String?
    
    var body: some View {
        ZStack {
            Color.orange.opacity(1)
                .frame(width: 210, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            VStack(alignment: .leading){
                Text(title)
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .lineLimit(nil)
                    .padding(.bottom, 4)
                    
                Spacer()
                Text(value ?? "")
                    .labelStyle(.titleAndIcon)
                    .font(.title)
                    .foregroundColor(.white)
                    .opacity(value == nil ? 0.0 : 1.0)
                Spacer()
            }
            .padding(16)
            .frame(width: 190, height: 140, alignment: .topLeading)
        }
    }
}

struct MetricsCardView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsCardView(title: "X", value: "X")
    }
}
