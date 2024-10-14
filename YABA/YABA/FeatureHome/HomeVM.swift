//
//  HomeVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

@Observable
class HomeVM {
    private(set) var shouldShowMiniButtons: Bool = false

    var shouldShowDeleteDialog: Bool = false
    var deletingContentLabel: String = ""
    
    var showBookmarkCreationSheet: Bool = false
    var showShareSheet: Bool = false
    
    var deletingFolder: Folder?
    var deletingTag: Tag?
    var deletingBookmark: Bookmark?
    var selectedBookmark: Bookmark?

    func toggleCreateMenu() {
        self.shouldShowMiniButtons.toggle()
    }

    func onShowDeleteDailog(folder: Folder) {
        self.deletingContentLabel = "Are you sure you want to delete \(folder.label), this can not be undone!"
        self.deletingFolder = folder
        self.shouldShowDeleteDialog = true
    }

    func onShowDeleteDailog(tag: Tag) {
        self.deletingContentLabel = "Are you sure you want to delete \(tag.label), this can not be undone!"
        self.deletingTag = tag
        self.shouldShowDeleteDialog = true
    }
    
    func onShowDeleteDialog(bookmark: Bookmark) {
        self.deletingContentLabel = "Are you sure you want to delete \(bookmark.label), this can not be undone!"
        self.deletingBookmark = bookmark
        self.shouldShowDeleteDialog = true
    }

    func onShowShareSheet(bookmark: Bookmark) {
        self.selectedBookmark = bookmark
        self.showShareSheet = true
    }
    
    func onCloseShareSheet() {
        self.selectedBookmark = nil
        self.showShareSheet = false
    }

    func onCloseDialog() {
        self.deletingContentLabel = ""
        self.deletingTag = nil
        self.deletingFolder = nil
        self.deletingBookmark = nil
        self.shouldShowDeleteDialog = false
    }

    func onFilterBookmarks(
        bookmarks: [Bookmark],
        searchQuery: String
    ) -> [Bookmark] {
        let isQueryEmpty = searchQuery.isEmpty

        let filteredBookmarks = bookmarks.filter { bookmark in
            // MARK: O(N*M) HERE. MAYBE REQUIRE A BETTER SOLUTION?
            let labelContainsQuery = bookmark.label
                .localizedCaseInsensitiveContains(searchQuery)
            let labelContainsDescription = bookmark.bookmarkDescription
                .localizedCaseInsensitiveContains(searchQuery)
            return isQueryEmpty ? true : (labelContainsQuery || labelContainsDescription)
        }

        let sortedBookmarks = filteredBookmarks.sorted {
            $0.createdAt < $1.createdAt
        }

        return sortedBookmarks
    }
}
