//
//  ModelConfigurator.swift
//  YABA
//
//  Created by Ali Taha on 13.10.2024.
//

import SwiftData

class ModelConfigurator {
    static func configureAndGetContainer() -> ModelContainer {
        let schema = Schema([
            Folder.self,
            Bookmark.self,
            Tag.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
    
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
