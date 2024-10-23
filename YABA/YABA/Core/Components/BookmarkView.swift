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
        VStack {
            HStack {
                HStack {
                    self.bookmarkIconBuilder
                    VStack(alignment: .leading) {
                        Text(
                            self.bookmark.label.isEmpty
                            ? "Bookmark Title"
                            : self.bookmark.label
                        )
                        .font(.headline)
                        .lineLimit(
                            self.bookmark.bookmarkDescription.isEmpty
                            ? 3
                            : 1
                        )
                        if !self.bookmark.bookmarkDescription.isEmpty {
                            Text(self.bookmark.bookmarkDescription)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            if !self.bookmark.tags.isEmpty {
                self.tags
            }
        }
        .onTapGesture {
            self.onPressed()
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
        if let image = self.bookmark.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else if !self.bookmark.folder.icon.isEmpty {
            Text(self.bookmark.folder.icon)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    self.bookmark.folder.primaryColor.getUIColor(),
                                    self.bookmark.folder.secondaryColor.getUIColor(),
                                    self.bookmark.folder.primaryColor.getUIColor(),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                }
                .frame(width: 80, height: 80)
                .padding(.trailing, 4)
        } else {
            self.bookmarkIcon
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)
                }
                .frame(width: 80, height: 80)
                .padding(.trailing, 4)
        }
    }

    @ViewBuilder
    private var bookmarkIcon: some View {
        Image(systemName: "bookmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30, alignment: .center)
    }
    
    @ViewBuilder
    private var tags: some View {
        HStack(alignment: .center) {
            if self.bookmark.tags.count <= 3 {
                ForEach(self.bookmark.tags) { tag in
                    self.createTagPresentation(for: tag)
                }
            } else {
                ForEach(self.bookmark.tags.prefix(upTo: 2)) { tag in
                    self.createTagPresentation(for: tag)
                }
                Text("+ \(self.bookmark.tags.count - 2) more")
                    .font(.caption2)
            }
            Spacer()
        }.frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func createTagPresentation(for tag: Tag) -> some View {
        HStack {
            Text(tag.icon)
                .font(.caption2)
            Text(tag.label)
                .font(.caption2)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    LinearGradient(
                        colors: [
                            tag.primaryColor.getUIColor(),
                            tag.secondaryColor.getUIColor(),
                            tag.primaryColor.getUIColor(),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .fill(
                    LinearGradient(
                        colors: [
                            tag.primaryColor.getUIColor().opacity(0.3),
                            tag.secondaryColor.getUIColor().opacity(0.3),
                            tag.primaryColor.getUIColor().opacity(0.3),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}

#Preview {
    BookmarkView(
        bookmark: Bookmark(
            link: "https://www.avanderlee.com",
            label: "Best SwiftUI Source",
            bookmarkDescription: "A source site that contains awesome SwiftUI content",
            domain: "avanderlee.com",
            createdAt: .now,
            imageData: nil,
            iconData: nil,
            videoUrl: nil,
            tags: [],
            folder: .empty()
        ),
        isInPreviewMode: false,
        onPressed: {},
        onSharePressed: {},
        onEditPressed: {},
        onDeletePressed: {}
    )
}
