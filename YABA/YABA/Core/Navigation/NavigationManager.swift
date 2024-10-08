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
        createBookmarkSheetActive = true
    }

    func onDismissBookmarkCreationSheet() {
        createBookmarkSheetActive = false
    }

    func showFolderCreationSheet() {
        createFolderSheetActive = true
    }

    func onDismissFolderCreationSheet() {
        createFolderSheetActive = false
    }

    func showTagCreationSheet() {
        createTagSheetActive = true
    }

    func onDismissTagCreationSheet() {
        createTagSheetActive = false
    }
}
