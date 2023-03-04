//
//  FileManager.swift
//  ErgoStats
//
//  Created by Alin Chitas on 02.03.2023.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
