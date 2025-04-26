//
//  TagsModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//
import Foundation

struct TagsResponse :Codable{
    var tags: [Tag]?
}

// MARK: - Tag
struct Tag :Codable{
    var id: Int?
    var name: String?
}
