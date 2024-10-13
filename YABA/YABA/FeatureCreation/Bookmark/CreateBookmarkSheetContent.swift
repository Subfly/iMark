//
//  CreateBookmarkSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateBookmarkSheetContent: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(sort: \Folder.createdAt, order: .forward)
    private var folders: [Folder]
    
    @Query(sort: \Tag.createdAt, order: .forward)
    private var tags: [Tag]

    @State
    var createBookmarkVM: CreateBookmarkVM
    
    let onDismiss: () -> Void
    
    init(bookmark: Bookmark?, onDismiss: @escaping () -> Void) {
        self.createBookmarkVM = .init(bookmark: bookmark)
        self.onDismiss = onDismiss
    }

    var body: some View {
        NavigationView {
            CreationSheetContentView(
                buttonLabel: self.createBookmarkVM.isEditMode ? "Update Bookmark" : "Create Bookmark"
            ) {
                // TASK: VALIDATE BEFORE SAVE
                self.modelContext.insert(self.createBookmarkVM.bookmark)
                self.onDismiss()
            } onDismissRequest: {
                self.onDismiss()
            } content: {
                self.formContent
            }
            .navigationTitle(self.createBookmarkVM.isEditMode ? "Update Bookmark" : "Create Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    self.cancelButton
                }
            }
            .popover(isPresented: self.$createBookmarkVM.shouldShowFolderSelectionPopover) {
                self.folderSelectionPopover
            }
            .sheet(isPresented: self.$createBookmarkVM.shouldShowCreateFolderSheet) {
                self.folderCreationSheetContent
            }
            .popover(isPresented: self.$createBookmarkVM.shouldShowTagSelectionPopover) {
                self.tagSelectionPopover
            }
            .sheet(isPresented: self.$createBookmarkVM.shouldShowCreateTagSheet) {
                self.createTagSheetContent
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        Button {
            self.onDismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    @ViewBuilder
    private var formContent: some View {
        VStack {
            Form {
                self.previewSection
                self.linkSection
                self.nameSection
                self.descriptionSection
                self.folderSelection
                self.tagSelection
            }
        }
    }
    
    @ViewBuilder
    private var previewSection: some View {
        CreateBookmarkBookmarkPreviewView(
            bookmark: self.createBookmarkVM.bookmark
        )
        .redacted(
            reason: self.createBookmarkVM.unfurling
            ? .placeholder
            : []
        )
        .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
    }
    
    @ViewBuilder
    private var linkSection: some View {
        Section {
            TextField(
                "Bookmark Link",
                text: self.$createBookmarkVM.bookmark.link
            )
            .keyboardType(.URL)
            .onChange(of: self.createBookmarkVM.bookmark.link) { _, newValue in
                Task {
                    await self.createBookmarkVM.onChangeLink(newValue)
                }
            }
        } header: {
            HStack {
                Image(systemName: "link")
                Text("Link")
            }
        } footer: {
            if self.createBookmarkVM.urlHasError {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(self.createBookmarkVM.urlErrorText)
                }.foregroundStyle(.red)
            } else if self.createBookmarkVM.urlHasWarning {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(self.createBookmarkVM.urlErrorText)
                }.foregroundStyle(.yellow)
            }
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section {
            TextField(
                "Bookmark Title",
                text: self.$createBookmarkVM.bookmark.label
            )
        } header: {
            HStack {
                Image(systemName: "t.square")
                Text("Title")
            }
        }
    }
    
    @ViewBuilder
    private var descriptionSection: some View {
        Section {
            TextField(
                "Bookmark Description",
                text: self.$createBookmarkVM.bookmark.bookmarkDescription,
                axis: .vertical
            )
        } header: {
            HStack {
                Image(systemName: "text.document")
                Text("Description")
            }
        }
    }
    
    @ViewBuilder
    private var folderSelection: some View {
        CreateBookmarkFolderSelectionView(
            selectedFolder: self.createBookmarkVM.bookmark.folder,
            onClickSelectFolder: {
                self.createBookmarkVM.onShowFolderSelectionPopover()
            }
        )
    }
    
    @ViewBuilder
    private var tagSelection: some View {
        CreateBookmarkTagSelectionView(
            tags: self.createBookmarkVM.bookmark.tags,
            onPressTag: {
                self.createBookmarkVM.onShowTagSelectionPopover()
            }
        )
    }
    
    @ViewBuilder
    private var folderSelectionPopover: some View {
        CreateBookmarkFolderSelectionPopover(
            folders: self.folders,
            onClickFolder: { folder in
                self.createBookmarkVM.onSelectFolder(folder: folder)
                self.createBookmarkVM.onCloseFolderSelectionPopover()
            },
            onClickCreateFolder: {
                self.createBookmarkVM.onShowFolderCreationSheet(folder: nil)
            },
            onDismiss: {
                self.createBookmarkVM.onCloseFolderSelectionPopover()
            }
        )
    }

    @ViewBuilder
    private var folderCreationSheetContent: some View {
        CreateFolderSheetContent(
            folder: self.createBookmarkVM.creationFolder,
            onDismiss: {
                self.createBookmarkVM.onCloseFolderCreationSheet()
            }
        )
    }

    @ViewBuilder
    private var tagSelectionPopover: some View {
        CreateBookmarkTagSelectionPopoverContent(
            selectedTags: self.createBookmarkVM.bookmark.tags,
            tags: self.tags,
            onPressTag: { tag in
                self.createBookmarkVM.onSelectTag(tag: tag)
            },
            onPressTagCreation: {
                self.createBookmarkVM.onShowTagCreationSheet(tag: nil)
            },
            onDismiss: {
                self.createBookmarkVM.onCloseTagSelectionPopover()
            }
        )
    }

    @ViewBuilder
    private var createTagSheetContent: some View {
        CreateTagSheetContent(
            tag: self.createBookmarkVM.creationTag,
            onDismiss: {
                self.createBookmarkVM.onCloseTagCreationSheet()
            }
        )
    }
}

#Preview {
    CreateBookmarkSheetContent(
        bookmark: .empty(),
        onDismiss: {}
    )
}
