//
//  TagView.swift
//  YABA
//
//  Created by Ali Taha on 9.10.2024.
//

import SwiftUI

struct TagView: View {
    let tag: Tag
    let isInPreviewMode: Bool
    let onPressed: () -> Void
    let onEditPressed: () -> Void
    let onDeletePressed: () -> Void

    var body: some View {
        Button {
            self.onPressed()
        } label: {
            HStack {
                if self.tag.icon.isEmpty {
                    Image(systemName: "tag")
                        .foregroundStyle(.white)
                } else {
                    Text(self.tag.icon)
                }
                Text(
                    self.tag.label.isEmpty
                    ? "Tag Name"
                    : self.tag.label
                )
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            }
            .padding()
            .background {
                Color.accentColor.clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                )
            }
            .contextMenu {
                if !self.isInPreviewMode {
                    self.menuContext
                }
            }
        }.buttonStyle(.plain)
    }

    @ViewBuilder
    private var menuContext: some View {
        Button {
            self.onEditPressed()
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        Divider()
        Button(role: .destructive) {
            self.onDeletePressed()
        } label: {
            Label("Delete", systemImage: "trash")
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    TagView(
        tag: Tag(
            label: "Cats",
            icon: "🐈",
            createdAt: .now
        ),
        isInPreviewMode: false,
        onPressed: {
            // Do Nothing
        },
        onEditPressed: {
            // Do Nothing
        },
        onDeletePressed: {
            // Do Nothing
        }
    )
}
