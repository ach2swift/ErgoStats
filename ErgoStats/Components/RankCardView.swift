//
//  RankCardView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 05.02.2023.
//

import SwiftUI

struct RankCardView: View {
    @ObservedObject var vm : RankViewModel
    
    let rankDescription = ["Recruit", "Second Liutenant", "First Liutenant", "Captain", "Major", "Liutenant Colonel", "Colonel", "Brigadier General", "Major General", "Liutenant General", "General" ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange.gradient)
                .frame(width: 300, height: 500)
            //            VStack{
            if vm.rankResult.target.rankIndex == 0 && !vm.rankError {
                VStack {
                    Text("You are just a ")
                    Image(systemName: "person")
                        .font(.system(size: 90))
                    Text("\(rankDescription[vm.rankResult.target.rankIndex])").font(.largeTitle)
                    Text("Pack your ERG bags if you want to go to the moon!")
                        .frame(maxWidth: 250)
                        .padding()
                }
            } else {
                VStack(spacing: 16){
                    Text("You are going to the moon as ")
                    Image("\(vm.rankResult.target.rankIndex)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("\(rankDescription[vm.rankResult.target.rankIndex])")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .padding()
                    VStack{
                        Text("Your rank is: \(vm.rankResult.target.rank)")
                        Text("Ammo: \(vm.rankResult.target.nanoErgsConverted, specifier: "%.0f") ERG")

                        VStack(alignment: .leading) {
                            if let above = vm.rankResult.above {
                                HStack{
                                    Text("Superior:")
                                    Text(above.address.prefix(6))
                                    Text("\(above.nanoErgsConverted, specifier: "%.0f") ERG")
                                }.fontWeight(.thin)
                            }
                            if let under = vm.rankResult.under {
                                HStack{
                                    Text("Subordinate:")
                                    Text(under.address.prefix(6))
                                    Text("\(under.nanoErgsConverted, specifier: "%.0f") ERG")
                                }.fontWeight(.thin)
                            }
                        }
                            .frame(maxWidth: 300)
                    }
                    .frame(maxWidth: 300)
                }
            }
        }
    }
}

struct RankCardView_Previews: PreviewProvider {
    static var previews: some View {
        RankCardView(vm: RankViewModel())
    }
}
