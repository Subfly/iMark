//
//  Tag.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftData

@Model
final class Tag {
    var label: String
    var icon: String
    var createdAt: Date

    init(label: String, icon: String, createdAt: Date) {
        self.label = label
        self.icon = icon
        self.createdAt = createdAt
    }
    
    static func empty() -> Tag {
        Tag(label: "", icon: "", createdAt: .now)
    }
}
