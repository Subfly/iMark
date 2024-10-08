//
//  Folder.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftData

@Model
final class Folder {
    @Relationship(deleteRule: .cascade)
    var bookmarks: [Bookmark]

    var label: String
    var createdAt: Date
    var icon: String?

    init(label: String, createdAt: Date, bookmarks: [Bookmark], icon: String? = nil) {
        self.label = label
        self.createdAt = createdAt
        self.bookmarks = bookmarks
        self.icon = icon
    }
}
