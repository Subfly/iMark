//
//  FolderListView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct FolderListView: View {
    let folders: [Folder]
    let noContentMessage: String
    let allowFolderAddition: Bool
    let isInPreviewMode: Bool
    let onClickFolder: (Folder) -> Void
    let onEditFolder: (Folder) -> Void
    let onDeleteFolder: (Folder) -> Void
    let onClickCreateFolder: (() -> Void)?
    
    var body: some View {
        VStack {
            if self.folders.isEmpty {
                self.noContentArea
            } else {
                self.folderListArea
            }
        }
    }
    
    @ViewBuilder
    private var noContentArea: some View {
        VStack {
            NoContentView(
                iconName: "folder",
                message: self.noContentMessage
            )
            if allowFolderAddition {
                DottedFolderView(
                    label: "Create Folder",
                    onClicked: {
                        if let onClickCreateFolder = self.onClickCreateFolder {
                            onClickCreateFolder()
                        }
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    private var folderListArea: some View {
        LazyVGrid(columns: [
            GridItem(),
            GridItem()
        ]) {
            if allowFolderAddition {
                DottedFolderView(
                    label: "Create Folder",
                    onClicked: {
                        if let onClickCreateFolder = self.onClickCreateFolder {
                            onClickCreateFolder()
                        }
                    }
                )
            }
            ForEach(self.folders) { folder in
                FolderView(
                    folder: folder,
                    isInPreviewMode: self.isInPreviewMode,
                    onClickFolder: {
                        self.onClickFolder(folder)
                    },
                    onEditPressed: {
                        self.onEditFolder(folder)
                    },
                    onDeletePressed: {
                        self.onDeleteFolder(folder)
                    }
                )
            }
        }.padding(.horizontal)
    }
}

#Preview {
    FolderListView(
        folders: [],
        noContentMessage: "",
        allowFolderAddition: false,
        isInPreviewMode: true,
        onClickFolder: { _ in },
        onEditFolder: { _ in },
        onDeleteFolder: { _ in },
        onClickCreateFolder: nil
    )
}
