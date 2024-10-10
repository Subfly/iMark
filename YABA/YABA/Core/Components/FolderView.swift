//
//  FolderView.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct FolderView: View {
    let folder: Folder
    let isInPreviewMode: Bool
    let onClickFolder: () -> Void
    let onEditPressed: () -> Void
    let onDeletePressed: () -> Void

    var body: some View {
        Button {
            if !self.isInPreviewMode {
                self.onClickFolder()
            }
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    self.imageArea
                    Spacer()
                    self.optionsArea
                }
                Spacer()
                    .frame(height: 18)
                self.textArea
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
        }
        .buttonStyle(.plain)
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

    @ViewBuilder
    private var optionsButton: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .blur(radius: 2)
                .foregroundStyle(.white.opacity(0.3))
            Image(systemName: "ellipsis")
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    private var imageArea: some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(width: 56, height: 56)
                .blur(radius: 2)
                .foregroundStyle(.white.opacity(0.3))
            if (self.folder.icon == nil || self.folder.icon?.isEmpty == true) && self.folder.label.isEmpty {
                Image(systemName: "folder")
                    .foregroundStyle(.white)
            } else {
                Text(
                    self.folder.icon
                    ?? self.folder.label.first?.uppercased()
                    ?? ""
                ).font(.system(size: 32))
            }
        }
    }
    
    @ViewBuilder
    private var optionsArea: some View {
        if self.isInPreviewMode {
            self.optionsButton
        } else {
            Menu {
                self.menuContext
            } label: {
                self.optionsButton
            }.buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var textArea: some View {
        Text(
            self.folder.label.isEmpty
            ? "Folder Name"
            : self.folder.label
        )
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
    }
}

#Preview {
    FolderView(
        folder: Folder(
            label: "Instagram",
            createdAt: .now,
            bookmarks: [],
            icon: "📷"
        ),
        isInPreviewMode: false,
        onClickFolder: {
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
