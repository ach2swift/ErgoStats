//
//  Model.swift
//  ErgoStats
//
//  Created by Alin Chitas on 03.02.2023.
//

import Foundation

struct AgeUSD: Codable {
    let reserveRatio, sigUsdPrice, sigRsvPrice: Int
}

struct SupplyDistribution: Codable {
    let absolute, relative: [AbsoluteRelative]
}

struct AbsoluteRelative: Codable, Identifiable {
    var id = UUID().uuidString
    let label: String
    let current, diff1D, diff1W, diff4W, diff6M, diff1Y : Double
    
    enum CodingKeys: String, CodingKey {
        case label, current
        case diff1D = "diff_1d"
        case diff1W = "diff_1w"
        case diff4W = "diff_4w"
        case diff6M = "diff_6m"
        case diff1Y = "diff_1y"
    }
}

struct MiningItem: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    
    let date: Date
    let ge1: Int
}

struct Mining: Codable {
    let timestamps, gt_0, ge_0p001, ge_0p01, ge_0p1, ge_1, ge_10, ge_100, ge_1k, ge_10k, ge_100k, ge_1m: [Int]
}

struct ContractsItem: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    
    let date: Date
    let ge1: Int
}

struct Contracts: Codable {
    let timestamps, gt_0, ge_0p001, ge_0p01, ge_0p1, ge_1, ge_10, ge_100, ge_1k, ge_10k, ge_100k, ge_1m: [Int]
}

struct AddressesItem: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    
    let date: Date
    let ge1: Int
}

struct Addresses: Codable {
    let timestamps, gt_0, ge_0p001, ge_0p01, ge_0p1, ge_1, ge_10, ge_100, ge_1k, ge_10k, ge_100k, ge_1m: [Int]
}


struct UTXOItem: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    
    let date: Date
    let utxo: Int
}

struct UTXOs: Codable {
    let timestamps, values: [Int]
}

struct TransactionItem: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    
    let date: Date
    let vol: Int
}

struct Transaction: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    let timestamps, daily1D, daily7D, daily28D: [Int]

    enum CodingKeys: String, CodingKey {
        case timestamps
        case daily1D = "daily_1d"
        case daily7D = "daily_7d"
        case daily28D = "daily_28d"
    }
}

struct VolumeItem: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    
    let date: Date
    let vol: Int
}

struct Volume: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    let timestamps, daily1D, daily7D, daily28D: [Int]

    enum CodingKeys: String, CodingKey {
        case timestamps
        case daily1D = "daily_1d"
        case daily7D = "daily_7d"
        case daily28D = "daily_28d"
    }
}

struct SummaryUsage: Codable, Identifiable {
    var id = UUID().uuidString
    let label: String
    let current, diff1D, diff1W, diff4W: Int
    let diff6M, diff1Y: Int

    enum CodingKeys: String, CodingKey {
        case label, current
        case diff1D = "diff_1d"
        case diff1W = "diff_1w"
        case diff4W = "diff_4w"
        case diff6M = "diff_6m"
        case diff1Y = "diff_1y"
    }
}

struct SummaryAddresses: Codable, Identifiable {
    var id = UUID().uuidString
    let label: String
    let current, diff1D, diff1W, diff4W: Int
    let diff6M, diff1Y: Int

    enum CodingKeys: String, CodingKey {
        case label, current
        case diff1D = "diff_1d"
        case diff1W = "diff_1w"
        case diff4W = "diff_4w"
        case diff6M = "diff_6m"
        case diff1Y = "diff_1y"
    }
}

struct PriceData: Identifiable, Codable {
    var id = UUID().uuidString
    let date: Date
    let price: Double
}

struct PriceChartModel: Codable, Identifiable {
    var id = UUID().uuidString
    let prices: [[Double]]
    let marketCaps: [[Double]]
    let totalVolumes: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices = "prices"
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
    
    static let example = PriceChartModel(prices: [[]], marketCaps: [[]], totalVolumes: [[]])
}


struct RichList: Codable {
    var address: String
    var balance: Int
}

struct RankResult: Codable {
    var above: RankItem?
    var target: RankItem
    var under: RankItem?
    
    static let example = RankResult(above: RankItem(rank: 0, address: "", balance: 0),
                                    target: RankItem(rank: 0, address: "", balance: 0),
                                    under: RankItem(rank: 0, address: "", balance: 0))
    
    init(above: RankItem, target: RankItem, under: RankItem) {
        self.above = above
        self.target = target
        self.under = under
    }
    
}

struct RankItem: Codable {
    let rank: Int
    let address: String
    let balance: Int
    
    var nanoErgsConverted: Double {
        return Double(balance / 1_000_000_000)
    }
    
    var rankIndex: Int {
        switch nanoErgsConverted {
        case let x where x >= 0 && x < 100:
            return 0
        case let x where x >= 100 && x < 1000:
            return 1
        case let x where x >= 1000 && x < 5000:
            return 2
        case let x where x >= 5000 && x < 15000:
            return 3
        case let x where x >= 15000 && x < 30000:
            return 4
        case let x where x >= 30000 && x < 50000:
            return 5
        case let x where x >= 50000 && x < 100000:
            return 6
        case let x where x >= 100000 && x < 250000:
            return 7
        case let x where x >= 250000 && x < 500000:
            return 8
        case let x where x >= 500_000 && x < 1_000_000:
            return 9
        case let x where x >= 1_000_000:
            return 10
        default:
            return 0
        }
    }
}
