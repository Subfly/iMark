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
    @Environment(NavigationManager.self)
    private var navigationManager

    @Environment(\.modelContext)
    private var modelContext

    @Bindable
    var createFolderVM: CreateFolderVM = .init()

    var body: some View {
        NavigationView {
            CreationSheetContentView(onCreateButtonLabel: "Create Folder") {
                let createdFolder = self.createFolderVM.getFolder()
                self.modelContext.insert(createdFolder)
                navigationManager.onDismissFolderCreationSheet()
            } onDismissRequest: {
                navigationManager.onDismissFolderCreationSheet()
            } content: {
                Form {
                    Section("Preview") {
                        FolderView(
                            folder: Folder(
                                label: self.createFolderVM.labelText,
                                createdAt: .now,
                                bookmarks: [],
                                icon: self.createFolderVM.selectedIcon
                            ),
                            isInPreviewMode: true,
                            onClickFolder: {},
                            onEditPressed: {},
                            onDeletePressed: {}
                        )
                        .frame(width: 200, alignment: .center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }.listRowBackground(Color(.systemGroupedBackground))
                    Section {
                        TextField(
                            "Folder Name",
                            text: self.$createFolderVM.labelText
                        ).onChange(of: self.createFolderVM.labelText) { _, newValue in
                            self.createFolderVM.onChaneLabel(newValue)
                        }
                    } header: {
                        Text("Info")
                    } footer: {
                        Text(self.createFolderVM.labelCounterText)
                            .foregroundStyle(self.createFolderVM.labelHasError ? .red : .secondary)
                    }
                    Section {
                        EmojiTextField(
                            text: self.$createFolderVM.selectedIcon,
                            placeholder: "Folder Icon"
                        ).onChange(of: self.createFolderVM.selectedIcon) { _, newValue in
                            self.createFolderVM.onChangeIcon(newValue)
                        }
                    } header: {
                        Text("Icon")
                    }
                }
            }
            .navigationTitle("Create Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationManager.onDismissFolderCreationSheet()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.8)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CreateFolderSheetContent()
}
