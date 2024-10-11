//
//  Bookmark.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftData

@Model
final class Bookmark {
    var link: String
    var label: String
    var bookmarkDescription: String
    var imageUrl: String
    var createdAt: Date
    var tags: [Tag]
    var folder: Folder?

    init(
        link: String,
        label: String,
        bookmarkDescription: String,
        imageUrl: String,
        createdAt: Date,
        tags: [Tag],
        folder: Folder?
    ) {
        self.link = link
        self.label = label
        self.bookmarkDescription = bookmarkDescription
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.tags = tags
        self.folder = folder
    }
    
    static func empty() -> Bookmark {
        Bookmark(
            link: "",
            label: "",
            bookmarkDescription: "",
            imageUrl: "",
            createdAt: .now,
            tags: [],
            folder: nil
        )
    }
}
