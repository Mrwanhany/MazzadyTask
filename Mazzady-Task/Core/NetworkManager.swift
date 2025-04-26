//
//  Helper.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//

import Network
import Foundation

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")

    public private(set) var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print(self?.isConnected == true ? "✅ Connected" : "❌ Disconnected")
        }
        monitor.start(queue: queue)
    }
}
