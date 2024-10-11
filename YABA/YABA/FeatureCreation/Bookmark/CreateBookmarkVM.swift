//
//  CreateBookmarkVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class CreateBookmarkVM {
    let isEditMode: Bool
    let labelLimit = 25
    let descriptionLimit = 120

    var labelCounterText: String
    var labelHasError: Bool = false

    var descriptionCounterText: String
    var descriptionHasError: Bool = false
    
    var shouldShowFolderSelectionPopover: Bool = false
    var shouldShowCreateFolderSheet: Bool = false
    
    var shouldShowTagSelectionPopover: Bool = false
    var shouldShowCreateTagSheet: Bool = false
    
    var creationFolder: Folder?
    var creationTag: Tag?
    
    var bookmark: Bookmark

    init(bookmark: Bookmark?) {
        self.labelCounterText = "0\\\(labelLimit)"
        self.descriptionCounterText = "0\\\(descriptionLimit)"
        self.bookmark = bookmark ?? .empty()
        self.isEditMode = bookmark != nil
    }

    func onChangeLink(_ text: String) {
        // TASK: SEND TO UNFURLING
        self.bookmark.link = text
    }

    func onChaneLabel(_ text: String) {
        if self.bookmark.label.count > self.labelLimit {
            self.bookmark.label = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.bookmark.label.count)\\\(self.labelLimit)"
        self.labelHasError = self.bookmark.label.count == self.labelLimit
    }

    func onChaneDescription(_ text: String) {
        if self.bookmark.bookmarkDescription.count > self.descriptionLimit {
            self.bookmark.bookmarkDescription = String(text.prefix(self.descriptionLimit))
        }
        self.descriptionCounterText = "\(self.bookmark.bookmarkDescription.count)\\\(self.descriptionLimit)"
        self.descriptionHasError = self.bookmark.bookmarkDescription.count == self.descriptionLimit
    }
    
    func onSelectFolder(folder: Folder) {
        self.bookmark.folder = folder
    }
    
    func onSelectTag(tag: Tag) {
        if self.bookmark.tags.contains(tag) {
            self.bookmark.tags.removeAll(where: { $0 == tag })
        } else {
            self.bookmark.tags.append(tag)
        }
    }
    
    func onShowFolderSelectionPopover() {
        self.shouldShowFolderSelectionPopover = true
    }
    
    func onCloseFolderSelectionPopover() {
        self.shouldShowFolderSelectionPopover = false
    }
    
    func onShowFolderCreationSheet(folder: Folder?) {
        self.creationFolder = folder
        self.shouldShowCreateFolderSheet = true
    }
    
    func onCloseFolderCreationSheet() {
        self.creationFolder = nil
        self.shouldShowCreateFolderSheet = false
    }
    
    func onShowTagSelectionPopover() {
        self.shouldShowTagSelectionPopover = true
    }
    
    func onCloseTagSelectionPopover() {
        self.shouldShowTagSelectionPopover = false
    }
    
    func onShowTagCreationSheet(tag: Tag?) {
        self.creationTag = tag
        self.shouldShowCreateTagSheet = true
    }
    
    func onCloseTagCreationSheet() {
        self.creationTag = nil
        self.shouldShowCreateTagSheet = false
    }
}
