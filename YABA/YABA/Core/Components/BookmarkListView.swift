//
//  BookmarkListView.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

import SwiftUI

struct BookmarkListView: View {
    let bookmarks: [Bookmark]
    let searchQuery: String
    let onPressBookmark: (Bookmark) -> Void
    let onShareBookmark: (Bookmark) -> Void
    let onEditBookmark: (Bookmark) -> Void
    let onDeleteBookmark: (Bookmark) -> Void
    
    var body: some View {
        if self.bookmarks.isEmpty {
            ContentUnavailableView(
                self.searchQuery.isEmpty ? "No Bookmarks Here" : "No Bookmarks Found",
                systemImage: "bookmark",
                description: Text(
                    self.searchQuery.isEmpty
                    ? """
It seems that you have not added any bookmarks to here yet. You can create on by using the '+' icon above.
""" : "No bookmarks matching '\(self.searchQuery)' found."
                )
            )
        } else {
            ForEach(self.bookmarks) { bookmark in
                BookmarkView(
                    bookmark: bookmark,
                    isInPreviewMode: false,
                    onPressed: {
                        self.onPressBookmark(bookmark)
                    },
                    onSharePressed: {
                        self.onShareBookmark(bookmark)
                    },
                    onEditPressed: {
                        self.onEditBookmark(bookmark)
                    },
                    onDeletePressed: {
                        self.onEditBookmark(bookmark)
                    }
                )
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        self.onShareBookmark(bookmark)
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }.tint(.indigo)
                }
                .swipeActions(allowsFullSwipe: true) {
                    Button {
                        self.onEditBookmark(bookmark)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }.tint(.orange)
                    Button(role: .destructive) {
                        self.onEditBookmark(bookmark)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }.tint(.red)
                }
            }
        }
    }
}

#Preview {
    BookmarkListView(
        bookmarks: [],
        searchQuery: "",
        onPressBookmark: { _ in },
        onShareBookmark: { _ in },
        onEditBookmark: { _ in },
        onDeleteBookmark: { _ in }
    )
}
