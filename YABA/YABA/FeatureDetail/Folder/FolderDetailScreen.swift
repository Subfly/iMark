//
//  FolderDetailScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI
import SwiftData

struct FolderDetailScreen: View {
    @Environment(NavigationManager.self)
    private var navigationManager
    
    let folder: Folder
    
    var body: some View {
        FolderDetailContent(
            folder: self.folder,
            onAddBookmark: {
                self.navigationManager.showBookmarkCreationSheet(bookmark: nil)
            },
            onSelectBookmark: { bookmark in
                self.navigationManager.navigate(to: .bookmark(bookmark: bookmark))
            }
        )
    }
}
