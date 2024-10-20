//
// PreloadDataHolder.swift
// YABA
//
// Created by Ali Taha on 14.10.2024.
//

import Foundation

struct PreloadDataHolder: Codable {
    let folders: [PreloadFolder]
    let tags: [PreloadTag]

    func getFolderModels() -> [Folder] {
        return self.folders.map { $0.toFolderModel() }
    }

    func getTagModels() -> [Tag] {
        return self.tags.map { $0.toTagModel() }
    }
}

struct PreloadFolder: Codable {
    let label: String
    let icon: String
    let primaryColor: YabaColor
    let secondaryColor: YabaColor

    func toFolderModel() -> Folder {
        return Folder(
            label: self.label,
            icon: self.icon,
            createdAt: .now,
            bookmarks: [],
            primaryColor: self.primaryColor,
            secondaryColor: self.secondaryColor
        )
    }

    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case icon = "icon"
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
    }
}

struct PreloadTag: Codable {
    let label: String
    let icon: String
    let primaryColor: YabaColor
    let secondaryColor: YabaColor

    func toTagModel() -> Tag {
        return Tag(
            label: self.label,
            icon: self.icon,
            createdAt: .now,
            primaryColor: self.primaryColor,
            secondaryColor: self.secondaryColor,
            bookmarks: []
        )
    }

    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case icon = "icon"
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
    }
}
