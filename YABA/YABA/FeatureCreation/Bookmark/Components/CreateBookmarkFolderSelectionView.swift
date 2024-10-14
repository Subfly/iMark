//
//  CreateBookmarkFolderSelectionView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct CreateBookmarkFolderSelectionView: View {
    let selectedFolder: Folder?
    let hasError: Bool
    let errorText: String
    let onClickSelectFolder: () -> Void
    
    var body: some View {
        Section {
            self.dynamicFolderView
                .frame(width: 200, alignment: .center)
                .frame(maxWidth: .infinity, alignment: .center)
        } header: {
            HStack {
                Image(systemName: "folder")
                Text("Folder")
            }.foregroundStyle(
                self.hasError
                ? .red
                : .secondary
            )
        } footer: {
            if self.hasError {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(self.errorText)
                }.foregroundStyle(
                    self.hasError
                    ? .red
                    : .secondary
                )
            }
        }
        .listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var dynamicFolderView: some View {
        if self.selectedFolder == nil {
            DottedFolderView(
                label: "Select a folder",
                hasError: self.hasError,
                onClicked: {
                    self.onClickSelectFolder()
                }
            ).padding(.vertical, 8)
        } else {
            if let folder = self.selectedFolder {
                FolderView(
                    folder: folder,
                    isInPreviewMode: true,
                    onClickFolder: {
                        self.onClickSelectFolder()
                    },
                    onEditPressed: {
                        /* Do Nothing */
                    },
                    onDeletePressed: {
                        /* Do Nothing */
                    }
                )
            }
        }
    }
}

#Preview {
    CreateBookmarkFolderSelectionView(
        selectedFolder: .empty(),
        hasError: false,
        errorText: "",
        onClickSelectFolder: {}
    )
}
