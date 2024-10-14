//
//  CreateBookmarkFolderSelectionPopoverContent.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct CreateBookmarkFolderSelectionPopover: View {
    let folders: [Folder]
    let onClickFolder: (Folder) -> Void
    let onClickCreateFolder: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                FolderListView(
                    folders: self.folders,
                    noContentMessage: """
It seems like you have not created any folder yet! Tap the button below to create your first folder.
""",
                    allowFolderAddition: true,
                    isInPreviewMode: true,
                    onClickFolder: { folder in
                        self.onClickFolder(folder)
                    },
                    onEditFolder: { _ in
                        /* Do Nothing */
                    },
                    onDeleteFolder: { _ in
                        /* Do Nothing */
                    },
                    onClickCreateFolder: {
                        self.onClickCreateFolder()
                    }
                )
            }
            .navigationTitle("Select Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.onDismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    CreateBookmarkFolderSelectionPopover(
        folders: [],
        onClickFolder: { _ in },
        onClickCreateFolder: {},
        onDismiss: {}
    )
}
