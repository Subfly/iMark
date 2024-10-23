//
//  TagDetailScreen.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

import SwiftUI
import SwiftData

struct TagDetailScreen: View {
    @Environment(NavigationManager.self)
    private var navigationManager
    
    let tag: Tag
    
    var body: some View {
        TagDetailContent(
            tag: self.tag,
            onAddBookmark: {
                self.navigationManager.showBookmarkCreationSheet(bookmark: nil)
            },
            onSelectBookmark: { bookmark in
                self.navigationManager.navigate(to: .bookmark(bookmark: bookmark))
            }
        )
    }
}

#Preview {
    TagDetailScreen(tag: .empty())
}
