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
    var primaryColor: YabaColor
    var secondaryColor: YabaColor

    init(
        label: String,
        icon: String,
        createdAt: Date,
        primaryColor: YabaColor,
        secondaryColor: YabaColor
    ) {
        self.label = label
        self.icon = icon
        self.createdAt = createdAt
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    static func empty() -> Tag {
        Tag(
            label: "",
            icon: "",
            createdAt: .now,
            primaryColor: .none,
            secondaryColor: .none
        )
    }
}
