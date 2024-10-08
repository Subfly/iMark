//
//  FolderView.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct FolderView: View {
    let folder: Folder

    var body: some View {
        VStack {
            // TODO: ADD BODY
        }
    }
}

#Preview {
    FolderView(
        folder: Folder(
            label: "Instagram",
            createdAt: .now,
            bookmarks: [],
            icon: "📷"
        )
    )
}
