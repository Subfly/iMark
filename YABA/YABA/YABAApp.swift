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
    let device = UIDevice.current.userInterfaceIdiom

    var body: some Scene {
        WindowGroup {
            if self.device == .phone {
                MobilePresentation()
            } else if self.device == .pad {
                TabletPresentation()
            }
        }
        .modelContainer(
            for: [Bookmark.self, Folder.self, Tag.self],
            inMemory: false,
            isAutosaveEnabled: false,
            isUndoEnabled: false
        )
    }
}
