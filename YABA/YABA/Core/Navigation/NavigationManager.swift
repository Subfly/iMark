//
//  NavigationManager.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

@Observable
class NavigationManager {
    var routes: NavigationPath = .init()

    var createBookmarkSheetActive: Bool = false
    var createFolderSheetActive: Bool = false
    var createTagSheetActive: Bool = false
    
    var selectedFolder: Folder?
    var selectedTag: Tag?
    var selectedBookmark: Bookmark?

    func navigate(to destination: Destination) {
        self.routes.append(destination)
    }

    func pop() {
        self.routes.removeLast()
    }

    func popToRoot() {
        self.routes = .init()
        self.routes.append(Destination.home)
    }

    func showBookmarkCreationSheet() {
        self.createBookmarkSheetActive = true
    }

    func onDismissBookmarkCreationSheet() {
        self.createBookmarkSheetActive = false
    }

    func showFolderCreationSheet(folder: Folder?) {
        self.selectedFolder = folder
        self.createFolderSheetActive = true
    }

    func onDismissFolderCreationSheet() {
        self.selectedFolder = nil
        self.createFolderSheetActive = false
    }

    func showTagCreationSheet(tag: Tag?) {
        self.selectedTag = tag
        self.createTagSheetActive = true
    }

    func onDismissTagCreationSheet() {
        self.selectedTag = nil
        self.createTagSheetActive = false
    }
}
