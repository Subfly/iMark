//
//  YABAApp.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI
import SwiftData

@main
struct YABAApp: App {
    @Bindable var navigationManager: NavigationManager = .init()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Folder.self,
            Bookmark.self,
            Tag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: self.$navigationManager.routes) {
                HomeScreen()
            }
            .sheet(isPresented: self.$navigationManager.createBookmarkSheetActive) {
                CreateBookmarkSheetContent(
                    bookmark: self.navigationManager.selectedBookmark,
                    onDismiss: {
                        self.navigationManager.onDismissBookmarkCreationSheet()
                    }
                )
            }
            .sheet(isPresented: self.$navigationManager.createFolderSheetActive) {
                CreateFolderSheetContent(
                    folder: self.navigationManager.selectedFolder,
                    onDismiss: {
                        self.navigationManager.onDismissFolderCreationSheet()
                    }
                )
            }
            .sheet(isPresented: self.$navigationManager.createTagSheetActive) {
                CreateTagSheetContent(
                    tag: self.navigationManager.selectedTag,
                    onDismiss: {
                        self.navigationManager.onDismissTagCreationSheet()
                    }
                )
            }
        }
        .modelContainer(sharedModelContainer)
        .environment(navigationManager)
    }
}
