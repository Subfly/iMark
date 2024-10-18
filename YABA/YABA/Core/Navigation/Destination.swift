//
//  Destination.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

enum Destination: Hashable {
    case home
    case settings
    case tag(tag: Tag)
    case folder(folder: Folder)
    case bookmark(bookmark: Bookmark)
    
    @ViewBuilder
    func getView() -> some View {
        switch self {
        case .home:
            HomeScreen()
        case .settings:
            SettingsScreen()
        case .tag(tag: let tag):
            TagDetailScreen(tag: tag)
        case .folder(folder: let folder):
            FolderDetailScreen(folder: folder)
        case .bookmark(bookmark: let bookmark):
            BookmarkDetailScreen(bookmark: bookmark)
        }
    }
}
