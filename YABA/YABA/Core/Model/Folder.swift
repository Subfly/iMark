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
    @Relationship(deleteRule: .cascade, inverse: \Bookmark.folder)
    var bookmarks: [Bookmark] = []

    var label: String
    var icon: String
    var createdAt: Date
    var primaryColor: YabaColor
    var secondaryColor: YabaColor

    init(
        label: String,
        icon: String,
        createdAt: Date,
        bookmarks: [Bookmark],
        primaryColor: YabaColor,
        secondaryColor: YabaColor
    ) {
        self.label = label
        self.createdAt = createdAt
        self.bookmarks = bookmarks
        self.icon = icon
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    static func empty() -> Folder {
        return Folder(
            label: "",
            icon: "",
            createdAt: .now,
            bookmarks: [],
            primaryColor: .none,
            secondaryColor: .none
        )
    }
}
