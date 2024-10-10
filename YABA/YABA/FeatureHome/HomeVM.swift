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
    var searchQuery: String = ""
    var deletingContentLabel: String = ""
    var deletingFolder: Folder?
    var deletingTag: Tag?

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

    func onCloseDialog() {
        self.deletingContentLabel = ""
        self.deletingTag = nil
        self.deletingFolder = nil
        self.shouldShowDeleteDialog = false
    }
}
