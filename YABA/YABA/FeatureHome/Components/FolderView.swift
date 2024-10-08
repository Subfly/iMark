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
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 48, height: 48)
                        .blur(radius: 8)
                    Text(folder.icon ?? folder.label.first?.uppercased() ?? "")
                }
            }
            Text(folder.label)
                .fontWeight(.semibold)
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
