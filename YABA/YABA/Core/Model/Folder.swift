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
    var icon: String
    var createdAt: Date

    init(label: String, icon: String, createdAt: Date, bookmarks: [Bookmark]) {
        self.label = label
        self.createdAt = createdAt
        self.bookmarks = bookmarks
        self.icon = icon
    }
    
    static func empty() -> Folder {
        return Folder(label: "", icon: "", createdAt: .now, bookmarks: [])
    }
}
