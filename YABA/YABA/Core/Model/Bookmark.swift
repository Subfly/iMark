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
    var link: URL
    var label: String
    var createdAt: Date
    var tags: [Tag]
    var bookmarkDescription: String?
    var imageUrl: URL?
    var folder: Folder?
    
    init(link: URL, label: String, createdAt: Date, tags: [Tag], bookmarkDescription: String? = nil, imageUrl: URL? = nil, folder: Folder? = nil) {
        self.link = link
        self.label = label
        self.createdAt = createdAt
        self.tags = tags
        self.bookmarkDescription = bookmarkDescription
        self.imageUrl = imageUrl
        self.folder = folder
    }
}
