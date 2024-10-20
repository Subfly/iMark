//
//  BookmarkDetailInfoSection.swift
//  YABA
//
//  Created by Ali Taha on 13.10.2024.
//

import SwiftUI

struct BookmarkDetailInfoSection: View {
    let bookmark: Bookmark
    let onClickFolder: (Folder) -> Void

    var body: some View {
        Section {
            self.folderInfoItem
            self.generateInfoItem(
                label: "Title",
                content: self.bookmark.label,
                iconSystemName: "t.square"
            )
            self.generateInfoItem(
                label: "Description",
                content: self.bookmark.bookmarkDescription,
                iconSystemName: "text.document"
            )
            self.generateInfoItem(
                label: "Creation Date",
                content: self.bookmark.createdAt.formatted(),
                iconSystemName: "calendar.badge.clock"
            )
        } header: {
            HStack {
                Image(systemName: "info.circle")
                Text("Info")
            }
        }
    }
    
    @ViewBuilder
    private func generateInfoItem(
        label: String,
        content: String,
        iconSystemName: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconSystemName)
                Text(label).fontWeight(.semibold)
            }
            Text(content).font(.callout)
        }
    }
    
    @ViewBuilder
    private var folderInfoItem: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "folder")
                Text("Folder").fontWeight(.semibold)
            }
            FolderView(
                folder: self.bookmark.folder,
                isInPreviewMode: true,
                onClickFolder: {
                    self.onClickFolder(self.bookmark.folder)
                },
                onEditPressed: {
                    /* Do Nothing */
                },
                onDeletePressed: {
                    /* Do Nothing */
                }
            )
            .frame(width: 200, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    BookmarkDetailInfoSection(
        bookmark: .empty(),
        onClickFolder: { _ in }
    )
}
