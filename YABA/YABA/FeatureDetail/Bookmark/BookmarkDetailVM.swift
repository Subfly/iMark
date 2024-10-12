//
//  BookmarkDetailVM.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

import SwiftUI

@Observable
class BookmarkDetailVM: ObservableObject {
    var bookmark: Bookmark
    
    var showBookmarkCreationSheet: Bool = false
    var showShareSheet: Bool = false
    var showBookmarkDeleteDialog: Bool = false
    
    var deletingBookmarkLabel: String = ""
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }
    
    func onShowBookmarkCreationSheet() {
        self.showBookmarkCreationSheet = true
    }
    
    func onCloseBookmarkCreationSheet() {
        self.showBookmarkCreationSheet = false
    }
    
    func onShowShareSheet() {
        self.showShareSheet = true
    }
    
    func onCloseShareSheet() {
        self.showShareSheet = false
    }
    
    func onShowBookmarkDeleteDialog() {
        self.deletingBookmarkLabel = "Are you sure you want to delete \(self.bookmark.label), this can not be undone!"
        self.showBookmarkDeleteDialog = true
    }
    
    func onCloseBookmarkDeleteDialog() {
        self.deletingBookmarkLabel = ""
        self.showBookmarkDeleteDialog = false
    }
}
