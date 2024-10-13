//
//  CreateBookmarkFolderSelectionView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct CreateBookmarkFolderSelectionView: View {
    let selectedFolder: Folder?
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
            }
        }
        .listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var dynamicFolderView: some View {
        if self.selectedFolder == nil {
            DottedFolderView(
                label: "Select a folder",
                onClicked: {
                    self.onClickSelectFolder()
                }
            ).padding(.top, 8)
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
        onClickSelectFolder: {}
    )
}
