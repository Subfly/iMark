//
//  FolderDetailContent.swift
//  YABA
//
//  Created by Ali Taha on 23.10.2024.
//

import SwiftUI
import SwiftData

struct FolderDetailContent: View {
    @AppStorage("folderSorting")
    private var folderDefaultSorting: Sorting = .date
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Query
    private var bookmarks: [Bookmark]
    
    @State
    private var folderDetailVM: FolderDetailVM
    
    @State
    private var searchQuery: String = ""

    @State
    private var animateGradient: Bool = false
    
    let onAddBookmark: () -> Void
    let onSelectBookmark: (Bookmark) -> Void
    
    init(
        folder: Folder,
        onAddBookmark: @escaping () -> Void,
        onSelectBookmark: @escaping (Bookmark) -> Void
    ) {
        self.folderDetailVM = .init(folder: folder)
        self.onAddBookmark = onAddBookmark
        self.onSelectBookmark = onSelectBookmark
    }
    
    var body: some View {
        List {
            self.bookmarkList
        }
        .scrollContentBackground(.hidden)
        .background {
            self.background
        }
        .navigationTitle(self.folderDetailVM.folder.label)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.onAddBookmark()
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
    private var background: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: self.getBackgroundGradientColors(),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.smooth(duration: 2.0).repeatForever(autoreverses: true)) {
                    self.animateGradient.toggle()
                }
            }
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
            onPressBookmark: self.onSelectBookmark,
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
            Task {
                if let bookmark = self.folderDetailVM.deletingBookmark {
                    self.modelContext.delete(bookmark)
                    try? await Task.sleep(for: .milliseconds(1))
                    try? self.modelContext.save()
                }
                self.folderDetailVM.onCloseBookmarkDeleteDialog()
            }
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
    
    private func getBackgroundGradientColors() -> [Color] {
        return [
            Color(UIColor.systemBackground),
            Color(UIColor.systemBackground),
            self.animateGradient
            ? self.folderDetailVM.folder.secondaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
            : self.folderDetailVM.folder.primaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
            self.animateGradient
            ? self.folderDetailVM.folder.primaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
            : self.folderDetailVM.folder.secondaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
        ]
    }
}

#Preview {
    FolderDetailContent(
        folder: .empty(),
        onAddBookmark: {
            // Do Nothing...
        },
        onSelectBookmark: { _ in
            // Do Nothing...
        }
    )
}
