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
            NavigationStack(path: $navigationManager.routes) {
                HomeScreen()
            }
            .sheet(isPresented: $navigationManager.createBookmarkSheetActive) {
                CreateBookmarkSheetContent()
            }
            .sheet(isPresented: $navigationManager.createFolderSheetActive) {
                CreateFolderSheetContent()
            }
            .sheet(isPresented: $navigationManager.createTagSheetActive) {
                CreateTagSheetContent()
            }
        }
        .modelContainer(sharedModelContainer)
        .environment(navigationManager)
    }
}
