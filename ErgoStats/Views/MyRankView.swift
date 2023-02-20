//
//  MyRankView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import SwiftUI

struct MyRankView: View {
    var myRank: Int
    
    var body: some View {
        Text("Your rank is: \(myRank) !")
    }
}

struct MyRankView_Previews: PreviewProvider {
    static var previews: some View {
        MyRankView(myRank: 0)
    }
}
