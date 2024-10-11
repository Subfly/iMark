//
//  BookmarkView.swift
//  YABA
//
//  Created by Ali Taha on 9.10.2024.
//

import SwiftUI

struct BookmarkView: View {
    let bookmark: Bookmark
    let isInPreviewMode: Bool
    let onPressed: () -> Void
    let onSharePressed: () -> Void
    let onEditPressed: () -> Void
    let onDeletePressed: () -> Void

    var body: some View {
        HStack {
            HStack {
                self.bookmarkIconBuilder
                VStack(alignment: .leading) {
                    Text(
                        self.bookmark.label.isEmpty ? "Bookmark Title" : self.bookmark.label
                    ).font(.headline)
                    if !self.bookmark.bookmarkDescription.isEmpty {
                        Text(self.bookmark.bookmarkDescription)
                            .lineLimit(2)
                            .font(.subheadline)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contextMenu {
            if !self.isInPreviewMode {
                self.menuContext
            }
        }
    }

    @ViewBuilder
    private var menuContext: some View {
        Button {
            self.onEditPressed()
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        Button {
            self.onSharePressed()
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
        Divider()
        Button(role: .destructive) {
            self.onDeletePressed()
        } label: {
            Label("Delete", systemImage: "trash")
                .foregroundStyle(.red)
        }
    }

    @ViewBuilder
    private var bookmarkIconBuilder: some View {
        if !self.bookmark.imageUrl.isEmpty {
            AsyncImage(
                url: URL(string: self.bookmark.imageUrl)
            ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    self.bookmarkIcon
                @unknown default:
                    self.bookmarkIcon
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        } else if self.bookmark.folder != nil {
            if self.bookmark.folder?.icon != nil || self.bookmark.folder?.icon.isEmpty == false {
                Text(self.bookmark.folder?.icon ?? "")
            } else {
                self.bookmarkIcon
            }
        } else {
            self.bookmarkIcon
        }
    }

    @ViewBuilder
    private var bookmarkIcon: some View {
        Image(systemName: "bookmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30, alignment: .center)
    }
}

#Preview {
    BookmarkView(
        bookmark: Bookmark(
            link: "https://www.avanderlee.com",
            label: "Best SwiftUI Source",
            bookmarkDescription: "A source site that contains awesome SwiftUI content",
            imageUrl: "https://www.avanderlee.com/wp-content/uploads/2020/04/avatar_126@3x-min.jpg",
            createdAt: .now,
            tags: [],
            folder: nil
        ),
        isInPreviewMode: false,
        onPressed: {},
        onSharePressed: {},
        onEditPressed: {},
        onDeletePressed: {}
    )
}
