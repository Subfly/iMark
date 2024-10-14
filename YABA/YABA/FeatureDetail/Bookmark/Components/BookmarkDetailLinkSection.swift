//
//  BookmarkDetailLinkSection.swift
//  YABA
//
//  Created by Ali Taha on 13.10.2024.
//

import SwiftUI

struct BookmarkDetailLinkSection: View {
    let bookmark: Bookmark
    let isLoading: Bool
    let onTapPreview: () -> Void
    
    var body: some View {
        Section {
            self.linkImageView
        }
        header: {
            HStack {
                Image(systemName: "rectangle.and.text.magnifyingglass")
                Text("Preview")
            }.padding(.leading)
        } footer: {
            HStack {
                Image(systemName: "link.circle.fill")
                Text(
                    self.bookmark.domain.isEmpty
                    ? self.bookmark.link
                    : self.bookmark.domain
                ).lineLimit(2)
            }.padding(.leading)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .redacted(reason: self.isLoading ? .placeholder : [])
        .onTapGesture {
            self.onTapPreview()
        }
    }

    @ViewBuilder
    private var linkImageView: some View {
        AsyncImage(
            url: URL(
                string: self.bookmark.imageUrl
            )
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                self.imageUnavailableView
            @unknown default:
                self.imageUnavailableView
            }
        }
        .frame(idealHeight: 256, alignment: .center)
    }

    @ViewBuilder
    private var imageUnavailableView: some View {
        ContentUnavailableView(
            "Image not Found",
            systemImage: "photo.badge.exclamationmark",
            description: Text(
                "The image of the bookmark can not be fetched currently, maybe it is removed or blocked?"
            )
        )
    }
}

#Preview {
    BookmarkDetailLinkSection(
        bookmark: .empty(),
        isLoading: false,
        onTapPreview: {}
    )
}