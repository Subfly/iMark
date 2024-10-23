//
//  BookmarkDetailScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct BookmarkDetailScreen: View {
    @Environment(NavigationManager.self)
    private var navigationManager
    
    let bookmark: Bookmark
    
    var body: some View {
        BookmarkDetailContent(
            bookmark: self.bookmark,
            onSelectFolder: { folder in
                self.navigationManager.navigate(to: .folder(folder: folder))
            },
            onSelectTag: { tag in
                self.navigationManager.navigate(to: .tag(tag: tag))
            },
            onCloseBookmarkDetail: {
                self.navigationManager.pop()
            }
        )
    }
}
