//
//  Bookmark.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Bookmark {
    @Attribute(.externalStorage, .allowsCloudEncryption)
    var imageData: Data?
    var image: UIImage? {
        if let data = self.imageData {
            return UIImage(data: data)
        }
        return nil
    }
    
    var iconData: Data?
    var icon: UIImage? {
        if let data = self.iconData {
            return UIImage(data: data)
        }
        return nil
    }
    
    var videoUrl: String?
    
    @Attribute(.spotlight)
    var label: String
    
    @Attribute(.spotlight)
    var bookmarkDescription: String
    
    var link: String
    var domain: String
    var createdAt: Date
    var tags: [Tag] = []
    var folder: Folder

    init(
        link: String,
        label: String,
        bookmarkDescription: String,
        domain: String,
        createdAt: Date,
        imageData: Data?,
        iconData: Data?,
        videoUrl: String?,
        tags: [Tag],
        folder: Folder
    ) {
        self.link = link
        self.label = label
        self.bookmarkDescription = bookmarkDescription
        self.domain = domain
        self.createdAt = createdAt
        self.imageData = imageData
        self.iconData = iconData
        self.videoUrl = videoUrl
        self.tags = tags
        self.folder = folder
    }
    
    static func empty() -> Bookmark {
        Bookmark(
            link: "",
            label: "",
            bookmarkDescription: "",
            domain: "",
            createdAt: .now,
            imageData: nil,
            iconData: nil,
            videoUrl: nil,
            tags: [],
            folder: .empty()
        )
    }
    
    static func empty(withLink link: String) -> Bookmark {
        Bookmark(
            link: link,
            label: "",
            bookmarkDescription: "",
            domain: "",
            createdAt: .now,
            imageData: nil,
            iconData: nil,
            videoUrl: nil,
            tags: [],
            folder: .empty()
        )
    }
}
