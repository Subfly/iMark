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
    var createdAt: Date
    var icon: String?
    
    init(label: String, createdAt: Date, icon: String? = nil) {
        self.label = label
        self.createdAt = createdAt
        self.icon = icon
    }
}
