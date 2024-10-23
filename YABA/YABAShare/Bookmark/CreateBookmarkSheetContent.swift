//
//  CreateBookmarkView.swift
//  YABAShare
//
//  Created by Ali Taha on 13.10.2024.
//
// swiftlint:disable all

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
    private var createBookmarkVM: CreateBookmarkVM
    
    @State
    private var createBookmarkNavigationManager: CreateBookmarkNavigationManager = .init()
    
    let onDismiss: () -> Void
    
    init(bookmark: Bookmark?, onDismiss: @escaping () -> Void) {
        self.createBookmarkVM = .init(
            bookmark: bookmark,
            isOpeningFromShareSheet: false
        )
        self.onDismiss = onDismiss
    }

    var body: some View {
        NavigationStack(path: self.$createBookmarkNavigationManager.routes) {
            NavigationView {
                CreationSheetContentView(
                    buttonLabel: self.createBookmarkVM.isEditMode ? "Update Bookmark" : "Create Bookmark",
                    hasError: self.createBookmarkVM.validationError
                ) {
                    if self.createBookmarkVM.validate() {
                        self.onSaveBookmark()
                    }
                } onDismissRequest: {
                    if self.createBookmarkNavigationManager.routes.isEmpty {
                        self.protectedOnDismiss()
                    }
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
            }.navigationDestination(for: CreateBookmarkDestination.self) { destination in
                switch destination {
                case .selectFolder:
                    FolderSelectionContent(
                        selectedFolder: self.createBookmarkVM.bookmark.folder,
                        onDoneSelectionCallback: { selectedFolder in
                            if let folder = selectedFolder {
                                self.createBookmarkVM.onSelectFolder(folder: folder)
                            }
                        }
                    )
                case .selectTags:
                    TagSelectionContent(
                        selectedTags: self.createBookmarkVM.bookmark.tags,
                        onDoneSelectionCallback: { tags in
                            self.createBookmarkVM.onSelectTags(tags: tags)
                        }
                    )
                }
            }
        }
        .presentationDragIndicator(.visible)
        .environment(self.createBookmarkNavigationManager)
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        Button {
            self.protectedOnDismiss()
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
            .disabled(self.createBookmarkVM.isEditMode)
        } header: {
            HStack {
                Image(systemName: "link")
                Text("Link")
            }.foregroundStyle(
                self.createBookmarkVM.urlHasError
                ? .red
                : self.createBookmarkVM.urlHasWarning
                ? .yellow
                : .secondary
            )
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
            ).onChange(of: self.createBookmarkVM.bookmark.label) { _, newValue in
                self.createBookmarkVM.onChangeLabel(newValue)
            }
        } header: {
            HStack {
                Image(systemName: "t.square")
                Text("Title")
            }.foregroundStyle(
                self.createBookmarkVM.labelHasValidationError
                ? .red
                : .secondary
            )
        } footer: {
            if self.createBookmarkVM.labelHasValidationError {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(self.createBookmarkVM.labelErrorText)
                }.foregroundStyle(
                    self.createBookmarkVM.labelHasValidationError
                    ? .red
                    : .secondary
                )
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
            hasError: self.createBookmarkVM.folderHasValidationError,
            errorText: self.createBookmarkVM.folderErrorText,
            onClickSelectFolder: {
                self.createBookmarkNavigationManager.navigate(to: .selectFolder)
            }
        )
    }
    
    @ViewBuilder
    private var tagSelection: some View {
        CreateBookmarkTagSelectionView(
            tags: self.createBookmarkVM.bookmark.tags,
            onPressTag: {
                self.createBookmarkNavigationManager.navigate(to: .selectTags)
            }
        )
    }
    
    private func onSaveBookmark() {
        Task {
            self.modelContext.insert(self.createBookmarkVM.bookmark)
            try? await Task.sleep(for: .milliseconds(1))
            try? self.modelContext.save()
            self.createBookmarkVM.onSaveBookmark()
            self.onDismiss()
        }
    }
    
    private func protectedOnDismiss() {
        Task {
            if !self.createBookmarkVM.isBookmarkSaved {
                self.modelContext.delete(self.createBookmarkVM.bookmark)
                try? await Task.sleep(for: .milliseconds(1))
                try? self.modelContext.save()
            }
            self.onDismiss()
        }
    }
}
