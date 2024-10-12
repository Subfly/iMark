//
//  FolderDetailScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI
import SwiftData

struct FolderDetailScreen: View {
    @AppStorage("folderSorting")
    private var folderDefaultSorting: Sorting = .date
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(NavigationManager.self)
    private var navigationManager
    
    @Query
    private var bookmarks: [Bookmark]
    
    @State
    private var folderDetailVM: FolderDetailVM
    
    @State
    private var searchQuery: String = ""
    
    init(folder: Folder) {
        self.folderDetailVM = .init(folder: folder)
    }
    
    var body: some View {
        List {
            self.bookmarkList
        }
        .navigationTitle(self.folderDetailVM.folder.label)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.navigationManager.showBookmarkCreationSheet()
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                self.contextMenu
            }
        }
        .sheet(isPresented: self.$folderDetailVM.showBookmarkCreationSheet) {
            self.bookmarkCreationContent
        }
        .sheet(isPresented: self.$folderDetailVM.showShareSheet) {
            self.shareSheetContent
        }
        .alert(
            self.folderDetailVM.deletingContentLabel,
            isPresented: self.$folderDetailVM.showBookmarkDeleteDialog
        ) {
            self.alertButtons
        }
        .searchable(
            text: self.$searchQuery,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search for bookmarks in \(self.folderDetailVM.folder.label)"
        )
    }
    
    @ViewBuilder
    private var bookmarkList: some View {
        let filteredBookmarks = self.folderDetailVM.onFilterBookmarks(
            bookmarks: self.bookmarks,
            sorting: self.folderDefaultSorting,
            searchQuery: self.searchQuery
        )
        BookmarkListView(
            bookmarks: filteredBookmarks,
            searchQuery: self.searchQuery,
            onPressBookmark: { bookmark in
                self.navigationManager.navigate(to: .bookmark(bookmark: bookmark))
            },
            onShareBookmark: { bookmark in
                self.folderDetailVM.onShowShareSheet(bookmark: bookmark)
            },
            onEditBookmark: { bookmark in
                self.folderDetailVM.onShowBookmarkCreationSheet(bookmark: bookmark)
            },
            onDeleteBookmark: { bookmark in
                self.folderDetailVM.onShowBookmarkDeleteDialog(bookmark: bookmark)
            }
        )
    }
    
    @ViewBuilder
    private var bookmarkCreationContent: some View {
        CreateBookmarkSheetContent(
            bookmark: self.folderDetailVM.selectedBookmark,
            onDismiss: {
                self.folderDetailVM.onCloseBookmarkCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var shareSheetContent: some View {
        if let bookmark = self.folderDetailVM.selectedBookmark {
            if let link = URL(string: bookmark.link) {
                ShareSheet(bookmarkLink: link)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .onDisappear {
                        self.folderDetailVM.onCloseShareSheet()
                    }
            }
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        Button(role: .destructive) {
            if let bookmark = self.folderDetailVM.deletingBookmark {
                self.modelContext.delete(bookmark)
            }
            self.folderDetailVM.onCloseBookmarkDeleteDialog()
        } label: {
            Text("Delete")
        }
        Button(role: .cancel) {
            self.folderDetailVM.onCloseBookmarkDeleteDialog()
        } label: {
            Text("Cancel")
        }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        Menu {
            ForEach(Sorting.allCases, id: \.rawValue) { sorting in
                Button {
                    self.folderDefaultSorting = sorting
                } label: {
                    HStack {
                        Text(sorting.getNaming())
                        Spacer()
                        if sorting == self.folderDefaultSorting {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        } label: {
            Button {
                self.folderDetailVM.showSortingMenu.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
        }
    }
}
