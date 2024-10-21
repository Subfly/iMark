//
//  CreateBookmarkFolderSelectionPopoverContent.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import Foundation
import SwiftData
import SwiftUI

struct FolderSelectionContent: View {
    @Environment(CreateBookmarkNavigationManager.self)
    private var createBookmarkNavigationManager
    
    @Query(sort: \Folder.createdAt, order: .forward)
    private var folders: [Folder]
    
    @State
    private var showFolderCreationSheet: Bool = false
    
    @State
    private var selectedFolder: Folder?
    
    let onDoneSelectionCallback: (Folder?) -> Void
    
    init(
        selectedFolder: Folder? = nil,
        onDoneSelectionCallback: @escaping (Folder?) -> Void
    ) {
        if selectedFolder?.label.isEmpty == true {
            self.selectedFolder = nil
        } else {
            self.selectedFolder = selectedFolder
        }
        self.onDoneSelectionCallback = onDoneSelectionCallback
    }
    
    var body: some View {
        ScrollView {
            self.foldersList
        }
        .navigationTitle("Select Folder")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.createBookmarkNavigationManager.pop()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.createBookmarkNavigationManager.pop()
                    self.onDoneSelectionCallback(self.selectedFolder)
                } label: {
                    Text("Done")
                }
            }
        }
        .sheet(isPresented: self.$showFolderCreationSheet) {
            CreateFolderSheetContent(
                folder: nil,
                onDismiss: {
                    withAnimation {
                        self.showFolderCreationSheet = false
                    }
                },
                onCreationCallback: { createdFolder in
                    self.createBookmarkNavigationManager.pop()
                    self.onDoneSelectionCallback(createdFolder)
                }
            )
        }
        .interactiveDismissDisabled()
    }
    
    @ViewBuilder
    private var foldersList: some View {
        FolderListView(
            folders: self.folders,
            noContentMessage: """
It seems like you have not created any folder yet! Tap the button below to create your first folder.
""",
            allowFolderAddition: true,
            isInPreviewMode: true,
            currentSelectedFolder: self.selectedFolder,
            onClickFolder: { folder in
                withAnimation {
                    self.selectedFolder = folder
                }
            },
            onEditFolder: { _ in
                /* Do Nothing */
            },
            onDeleteFolder: { _ in
                /* Do Nothing */
            },
            onClickCreateFolder: {
                withAnimation {
                    self.showFolderCreationSheet = true
                }
            }
        )
    }
}

#Preview {
    FolderSelectionContent(
        onDoneSelectionCallback: { _ in
            // Do Nothing...
        }
    )
}
