//
//  CreateFolderSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateFolderSheetContent: View {
    @Environment(\.modelContext)
    private var modelContext

    @State
    private var createFolderVM: CreateFolderVM

    let onDismiss: () -> Void
    
    init(
        folder: Folder?,
        onDismiss: @escaping () -> Void
    ) {
        self.createFolderVM = .init(folder: folder)
        self.onDismiss = onDismiss
    }

    var body: some View {
        NavigationView {
            CreationSheetContentView(
                buttonLabel: self.createFolderVM.isEditMode ? "Edit Folder" : "Create Folder"
            ) {
                // TASK: VALIDATE BEFORE SAVE
                self.modelContext.insert(self.createFolderVM.folder)
                self.onDismiss()
            } onDismissRequest: {
                self.onDismiss()
            } content: {
                Form {
                    self.previewSection
                    self.nameSection
                    self.iconSection
                }
            }
            .navigationTitle(self.createFolderVM.isEditMode ? "Edit Folder" : "Create Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.onDismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.8)])
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    private var previewSection: some View {
        Section {
            FolderView(
                folder: self.createFolderVM.folder,
                isInPreviewMode: true,
                onClickFolder: {},
                onEditPressed: {},
                onDeletePressed: {}
            )
            .frame(width: 200, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        } header: {
            HStack {
                Image(systemName: "rectangle.and.text.magnifyingglass")
                Text("Preview")
            }
        }
        .listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section {
            TextField(
                "Folder Name",
                text: self.$createFolderVM.folder.label
            ).onChange(of: self.createFolderVM.folder.label) { _, newValue in
                self.createFolderVM.onChaneLabel(newValue)
            }
        } header: {
            HStack {
                Image(systemName: "t.square")
                Text("Name")
            }
        } footer: {
            Text(self.createFolderVM.labelCounterText)
                .foregroundStyle(self.createFolderVM.labelHasError ? .red : .secondary)
        }
    }
    
    @ViewBuilder
    private var iconSection: some View {
        Section {
            EmojiTextField(
                text: self.$createFolderVM.folder.icon,
                placeholder: "Folder Icon"
            ).onChange(of: self.createFolderVM.folder.icon) { _, newValue in
                self.createFolderVM.onChangeIcon(newValue)
            }
        } header: {
            HStack {
                Image(systemName: "app")
                Text("Icon")
            }
        }
    }
}

#Preview {
    CreateFolderSheetContent(
        folder: .empty(),
        onDismiss: {}
    )
}
