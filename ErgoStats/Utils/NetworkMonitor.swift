//
//  NetworkMonitor.swift
//  ErgoStats
//
//  Created by Alin Chitas on 23.02.2023.
//

import Foundation
import Network

@MainActor class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isActive: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
//                self.isActive = path.status == .satisfied
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                self.objectWillChange.send()
            }
        }
        monitor.start(queue: queue)
    }
}
