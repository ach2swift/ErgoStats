//
//  RichListView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import SwiftUI
import WebKit

struct RichListView: View {
    @State private var showWebView = false
    @State private var showAddress = ""
    @StateObject var viewModel = RichListViewModel()

    
    var body: some View {
        NavigationStack{
            List{
                ForEach(viewModel.richList, id: \.address) { richRow in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(richRow.address.prefix(6))
                                .font(.headline)
                            Text("\(richRow.balance / 1_000_000_000) ERG") //nanoERG to ERG
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.orange)
                    }
                    .onTapGesture {
                        showAddress = richRow.address
                        showWebView.toggle()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .sheet(isPresented: $showWebView) {
                WebView(address: $showAddress)
//                    .presentationDetents([.medium, .large])
            }
            .presentationDetents([.medium])
            .navigationTitle("Top 100 Rich List")
            .task {
                await viewModel.fetchRichList()
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let firstPart = "https://explorer.ergoplatform.com/en/addresses/"
    @Binding var address: String
    
    var finalURL: String {
        firstPart + address
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let urlStr = URL(string: finalURL) else { return }
        let request = URLRequest(url: urlStr)
        DispatchQueue.main.async {
            uiView.load(request)
        }
    }
}

struct RichListView_Previews: PreviewProvider {
    static var previews: some View {
        RichListView()
    }
}
