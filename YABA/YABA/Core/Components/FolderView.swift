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
            self.onClickFolder()
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
                RoundedRectangle(cornerRadius: 16)
                    .fill(self.getGradient())
            }
            .shadow(radius: 2)
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
            if (self.folder.icon.isEmpty == true) && self.folder.label.isEmpty {
                Image(systemName: "folder")
                    .foregroundStyle(.white)
            } else {
                Text(
                    (self.folder.icon.isEmpty ? self.folder.label.first?.uppercased() : self.folder.icon)
                    ?? ""
                )
                .font(.system(size: 32))
                .foregroundStyle(.white)
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
        .lineLimit(1)
    }
    
    private func getGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                self.folder.primaryColor.getUIColor(),
                self.folder.secondaryColor.getUIColor(),
                self.folder.primaryColor.getUIColor(),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    FolderView(
        folder: Folder(
            label: "Instagram",
            icon: "📷",
            createdAt: .now,
            bookmarks: [],
            primaryColor: .green,
            secondaryColor: .cyan
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
