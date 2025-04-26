//
//  BannerModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//
import Foundation
struct BannerResponse: Codable {
    let advertisements: [Banner]
}

struct Banner: Codable {
    let id: Int
    let image: String
}
