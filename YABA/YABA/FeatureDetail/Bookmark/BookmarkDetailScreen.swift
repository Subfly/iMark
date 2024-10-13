//
//  BookmarkDetailScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct BookmarkDetailScreen: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(NavigationManager.self)
    private var navigationManager
    
    @State
    private var bookmarkDetailVM: BookmarkDetailVM
    
    init(bookmark: Bookmark) {
        self.bookmarkDetailVM = .init(bookmark: bookmark)
    }
    
    var body: some View {
        List {
            self.linkSection
            self.infoSection
            self.tagsSection
        }
        .navigationTitle("Bookmark Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.bookmarkDetailVM.onShowBookmarkCreationSheet()
                } label: {
                    Image(systemName: "pencil")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                self.contextMenu
            }
        }
        .sheet(isPresented: self.$bookmarkDetailVM.showBookmarkCreationSheet) {
            CreateBookmarkSheetContent(
                bookmark: self.bookmarkDetailVM.bookmark,
                onDismiss: {
                    self.bookmarkDetailVM.onCloseBookmarkCreationSheet()
                }
            )
        }
        .sheet(isPresented: self.$bookmarkDetailVM.showShareSheet) {
            self.shareSheetContent
        }
        .alert(
            self.bookmarkDetailVM.deletingBookmarkLabel,
            isPresented: self.$bookmarkDetailVM.showBookmarkDeleteDialog
        ) {
            self.alertButtons
        }
    }
    
    @ViewBuilder
    private var linkSection: some View {
        BookmarkDetailLinkSection(
            bookmark: self.bookmarkDetailVM.bookmark,
            isLoading: self.bookmarkDetailVM.unfurling,
            onTapPreview: {
                self.bookmarkDetailVM.onClickOpenLink()
            }
        )
    }
    
    @ViewBuilder
    private var infoSection: some View {
        Section {
            self.folderInfoItem
            self.generateInfoItem(
                label: "Title",
                content: self.bookmarkDetailVM.bookmark.label,
                iconSystemName: "t.square"
            )
            self.generateInfoItem(
                label: "Description",
                content: self.bookmarkDetailVM.bookmark.bookmarkDescription,
                iconSystemName: "text.document"
            )
            self.generateInfoItem(
                label: "Creation Date",
                content: self.bookmarkDetailVM.bookmark.createdAt.formatted(),
                iconSystemName: "calendar.badge.clock"
            )
        } header: {
            HStack {
                Image(systemName: "info.circle")
                Text("Info")
            }
        }
    }
    
    @ViewBuilder
    private func generateInfoItem(
        label: String,
        content: String,
        iconSystemName: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconSystemName)
                Text(label).fontWeight(.semibold)
            }
            Text(content).font(.callout)
        }
    }
    
    @ViewBuilder
    private var folderInfoItem: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "folder")
                Text("Folder").fontWeight(.semibold)
            }
            if let folder = self.bookmarkDetailVM.bookmark.folder {
                FolderView(
                    folder: folder,
                    isInPreviewMode: true,
                    onClickFolder: {
                        self.navigationManager.navigate(to: .folder(folder: folder))
                    },
                    onEditPressed: {
                        /* Do Nothing */
                    },
                    onDeletePressed: {
                        /* Do Nothing */
                    }
                )
                .frame(width: 200, alignment: .center)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    @ViewBuilder
    private var tagsSection: some View {
        Section {
            TagsFlowView(
                tags: self.bookmarkDetailVM.bookmark.tags,
                noContentMessage:
                    "No tags are added to this bookmark yet. You can add some by editing the bookmark.",
                allowTagAddition: false,
                isInPreviewMode: true,
                onPressTag: { tag in
                    self.navigationManager.navigate(to: .tag(tag: tag))
                },
                onEditTag: { _ in
                    /* Do Nothing */
                },
                onDeleteTag: { _ in
                    /* Do Nothing */
                },
                onClickTagCreation: {
                    /* Do Nothing */
                }
            )
        } header: {
            HStack {
                Image(systemName: "tag")
                Text("Tags")
            }
        }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        Menu {
            Button {
                self.bookmarkDetailVM.onShowShareSheet()
            } label: {
                Label {
                    Text("Share")
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            Button {
                Task {
                    await self.bookmarkDetailVM.onRefreshBookmark()
                    self.modelContext.insert(self.bookmarkDetailVM.bookmark)
                }
            } label: {
                Label {
                    Text("Refresh Preview")
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            Divider()
            Button(role: .destructive) {
                self.bookmarkDetailVM.onShowBookmarkDeleteDialog()
            } label: {
                Label {
                    Text("Delete")
                } icon: {
                    Image(systemName: "trash")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
    @ViewBuilder
    private var shareSheetContent: some View {
        if let link = URL(string: self.bookmarkDetailVM.bookmark.link) {
            ShareSheet(bookmarkLink: link)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .onDisappear {
                    self.bookmarkDetailVM.onCloseShareSheet()
                }
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        Button(role: .destructive) {
            self.modelContext.delete(self.bookmarkDetailVM.bookmark)
            self.bookmarkDetailVM.onCloseBookmarkDeleteDialog()
            self.navigationManager.pop()
        } label: {
            Text("Delete")
        }
        Button(role: .cancel) {
            self.bookmarkDetailVM.onCloseBookmarkDeleteDialog()
        } label: {
            Text("Cancel")
        }
    }
}
