//
//  BookmarkDetailContextMenu.swift
//  YABA
//
//  Created by Ali Taha on 13.10.2024.
//

import SwiftUI

struct BookmarkDetailContextMenu: View {
    let onShowShareSheet: () -> Void
    let onRefreshBookmark: () -> Void
    let onShowBookmarkDeleteDialog: () -> Void

    var body: some View {
        Menu {
            Button {
                self.onShowShareSheet()
            } label: {
                Label {
                    Text("Share")
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            Button {
                self.onRefreshBookmark()
            } label: {
                Label {
                    Text("Refresh Preview")
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            Divider()
            Button(role: .destructive) {
                self.onShowBookmarkDeleteDialog()
            } label: {
                Label {
                    Text("Delete")
                } icon: {
                    Image(systemName: "trash")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

#Preview {
    BookmarkDetailContextMenu(
        onShowShareSheet: {},
        onRefreshBookmark: {},
        onShowBookmarkDeleteDialog: {}
    )
}
