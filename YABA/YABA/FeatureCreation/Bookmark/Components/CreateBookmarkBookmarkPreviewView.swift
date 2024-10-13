//
//  CreateBookmarkBookmarkPreviewView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct CreateBookmarkBookmarkPreviewView: View {
    let bookmark: Bookmark

    var body: some View {
        Section {
            BookmarkView(
                bookmark: self.bookmark,
                isInPreviewMode: true,
                onPressed: {},
                onSharePressed: {},
                onEditPressed: {},
                onDeletePressed: {}
            )
            .padding()
        } header: {
            HStack {
                Image(systemName: "rectangle.and.text.magnifyingglass")
                Text("Preview")
            }.padding(.leading)
        }
    }
}

#Preview {
    CreateBookmarkBookmarkPreviewView(
        bookmark: .empty()
    )
}
