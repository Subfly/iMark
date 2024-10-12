//
//  FolderDetailVM.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

import SwiftUI

@Observable
class FolderDetailVM {
    var folder: Folder
    var selectedBookmark: Bookmark?
    var deletingBookmark: Bookmark?
    
    var deletingContentLabel: String = ""

    var showBookmarkCreationSheet: Bool = false
    var showBookmarkDeleteDialog: Bool = false
    var showShareSheet: Bool = false
    var showSortingMenu: Bool = false
    
    init(folder: Folder) {
        self.folder = folder
    }
    
    func onFilterBookmarks(
        bookmarks: [Bookmark],
        sorting: Sorting,
        searchQuery: String
    ) -> [Bookmark] {
        let isQueryEmpty = searchQuery.isEmpty
        
        let filteredBookmarks = bookmarks.filter { bookmark in
            let bookmarkContained = bookmark.folder?.id == self.folder.id
            let labelContainsQuery = bookmark.label
                .localizedCaseInsensitiveContains(searchQuery)
            let labelContainsDescription = bookmark.bookmarkDescription
                .localizedCaseInsensitiveContains(searchQuery)
            return bookmarkContained && (isQueryEmpty ? true : (labelContainsQuery || labelContainsDescription))
        }
        
        let sortedBookmarks = filteredBookmarks.sorted {
            switch sorting {
            case .alphabetical:
                $0.label < $1.label
            case .reverseAlphabetical:
                $0.label > $1.label
            case .date:
                $0.createdAt < $1.createdAt
            case .reverseDate:
                $0.createdAt > $1.createdAt
            }
        }
        
        return sortedBookmarks
    }
    
    func onShowBookmarkCreationSheet(bookmark: Bookmark) {
        self.selectedBookmark = bookmark
        self.showBookmarkCreationSheet = true
    }
    
    func onCloseBookmarkCreationSheet() {
        self.showBookmarkCreationSheet = false
        self.selectedBookmark = nil
    }
    
    func onShowBookmarkDeleteDialog(bookmark: Bookmark) {
        self.deletingContentLabel = "Are you sure you want to delete \(bookmark.label), this can not be undone!"
        self.deletingBookmark = bookmark
        self.showBookmarkDeleteDialog = true
    }
    
    func onCloseBookmarkDeleteDialog() {
        self.deletingContentLabel = ""
        self.deletingBookmark = nil
        self.showBookmarkDeleteDialog = false
    }
    
    func onShowShareSheet(bookmark: Bookmark) {
        self.selectedBookmark = bookmark
        self.showShareSheet = true
    }
    
    func onCloseShareSheet() {
        self.selectedBookmark = nil
        self.showShareSheet = false
    }
}
