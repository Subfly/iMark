//
//  TabletPresentationVM.swift
//  YABA
//
//  Created by Ali Taha on 23.10.2024.
//

import SwiftUI

@Observable
class TabletPresentationVM {
    var visibility: NavigationSplitViewVisibility = .all
    
    var shouldShowMiniButtons: Bool = false
    var showShareSheet: Bool = false
    var shouldShowDeleteDialog: Bool = false
    
    var deletingContentLabel: String = ""
    
    var deletingFolder: Folder?
    var deletingTag: Tag?
    var deletingBookmark: Bookmark?
    
    var selectedFolder: Folder?
    var selectedTag: Tag?
    var selectedBookmark: Bookmark?
    
    var sharedBookmark: Bookmark?
    
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
        self.sharedBookmark = bookmark
        self.showShareSheet = true
    }
    
    func onCloseShareSheet() {
        self.sharedBookmark = nil
        self.showShareSheet = false
    }

    func onCloseDialog() {
        self.deletingContentLabel = ""
        self.deletingTag = nil
        self.deletingFolder = nil
        self.deletingBookmark = nil
        self.shouldShowDeleteDialog = false
    }
    
    func onSelectFolder(folder: Folder) {
        self.selectedTag = nil
        self.selectedBookmark = nil
        self.selectedFolder = folder
    }
    
    func onSelectTag(tag: Tag) {
        self.selectedFolder = nil
        self.selectedBookmark = nil
        self.selectedTag = tag
    }
    
    func onSelectBookmark(bookmark: Bookmark) {
        self.selectedBookmark = bookmark
    }
    
    func onBookmarkDeletedInDetail() {
        self.selectedBookmark = nil
    }
}
