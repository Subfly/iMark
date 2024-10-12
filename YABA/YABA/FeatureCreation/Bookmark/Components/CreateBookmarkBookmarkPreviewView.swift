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
        Section("Preview") {
            BookmarkView(
                bookmark: self.bookmark,
                isInPreviewMode: true,
                onPressed: {},
                onSharePressed: {},
                onEditPressed: {},
                onDeletePressed: {}
            )
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 90, alignment: .center)
            .background {
                Color(.secondarySystemGroupedBackground).clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }.listRowBackground(Color(.systemGroupedBackground))
    }
}

#Preview {
    CreateBookmarkBookmarkPreviewView(
        bookmark: .empty()
    )
}
