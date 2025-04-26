//
//  ProductModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 24/04/2025.
//

import Foundation

struct ProductResponse: Codable {
    let name: String
    let image: String
    let price: Double?
    let currency: String
    let offer: Double?
    let end_date: Double?
}

