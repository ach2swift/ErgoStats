//
//  RankView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import ConfettiSwiftUI
import SwiftUI

enum NavType: String, Hashable {
    case rankLegend = "RANK LEGEND"
    case rank = "RANK"
}

struct RankView: View {
    @State private var mainStack: [NavType] = []
    @StateObject var viewModel = RankViewModel()
    @StateObject var manager = TFManager()
    @State private var isTapped = false
    @State private var counter: Int = 0
    @FocusState private var addressIsFocused: Bool
    
    var body: some View {
        NavigationStack(path: $mainStack) {
                if viewModel.isLoadingRank {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                } else {
                    if !viewModel.rankResult.target.address.isEmpty {
                        ScrollView(showsIndicators: false){
                            RankCardView(vm: viewModel)
                                .onTapGesture {
                                    counter += 1
                                }
                                .confettiCannon(counter: $counter)
                        }
                    } else if viewModel.rankError {
                        Spacer()
                        Label("Please input a correct address and try again", systemImage: "x.circle")
                            .padding()
                    }
                }
                if viewModel.rankResult.target.address.isEmpty {
                    ScrollView(showsIndicators: false){
                        RankHintView()
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                VStack {
                    VStack(alignment: .leading, spacing: 4, content: {
                        
                        HStack(spacing: 15) {
                            
                            TextField("", text: $manager.address) { (status) in
                                if status {
                                    withAnimation(.easeIn) {
                                        isTapped = true
                                    }
                                }
                            } onCommit: {
                                if manager.address == "" {
                                    withAnimation(.easeOut) {
                                        isTapped = false
                                    }
                                }
                            }
                            .focused($addressIsFocused)
                            
                            Button(action: {
                                addressIsFocused = false
                                Task {
                                    await viewModel.fetchRank(inputAddress: manager.address)
                                }
                            }, label: {
                                Image(systemName: "play.fill")
                                    .foregroundColor(manager.address.isEmpty || !manager.address.hasPrefix("9") || manager.address.count < 51 ? .gray : .orange)
                            }).disabled(manager.address.isEmpty || !manager.address.hasPrefix("9") || manager.address.count < 51)
                            
                        }
                        .padding(.top, isTapped ? 15 : 0)
                        .background(
                            Text("Paste in your ERG address")
                                .scaleEffect(isTapped ? 0.8 : 1)
                                .offset(x: isTapped ? -7 : 0, y: isTapped ? -15 : 0)
                                .foregroundColor(isTapped ? .orange : .gray)
                            
                            
                            ,alignment: .leading
                        )
                        .padding(.horizontal)
                        
                        Rectangle()
                            .fill(isTapped ? Color.orange : Color.gray)
                            .opacity(isTapped ? 1 : 0.5)
                            .frame(height: 1)
                            .padding(.top, 10)
                    })
                    .padding(.top, 12)
                    .background(Color.gray.opacity(0.09))
                    .cornerRadius(5)
                    
                    HStack {
                        Spacer()
                        
                        Text("\(manager.address.count)/51")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                            .padding(.top, 3)
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            mainStack.append(.rankLegend)
                        }label: {
                            Label("Legend", systemImage: "list.number")
                                .tint(.orange)
                        }
                    }
                }
                .navigationDestination(for: NavType.self) { value in
                    switch value {
                    case .rankLegend:
                        RankLegendView()
                    case .rank: RankView()
                    }
                }
        }
    }
}


class TFManager: ObservableObject {
    @Published var address = ""{
        didSet{
            if address.count > 51 && oldValue.count <= 51 {
                address = oldValue
            }
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        RankView()
    }
}
