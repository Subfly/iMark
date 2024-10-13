//
//  TagDetailScreen.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

import SwiftUI
import SwiftData

struct TagDetailScreen: View {
    @AppStorage("tagSorting")
    private var tagDefaultSorting: Sorting = .date
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(NavigationManager.self)
    private var navigationManager

    @Environment(\.colorScheme)
    private var colorScheme

    @Query
    private var bookmarks: [Bookmark]
    
    @State
    private var tagDetailVM: TagDetailVM
    
    @State
    private var searchQuery: String = ""

    @State
    private var animateGradient: Bool = false
    
    init(tag: Tag) {
        self.tagDetailVM = .init(tag: tag)
    }
    
    var body: some View {
        List {
            self.bookmarkList
        }
        .scrollContentBackground(.hidden)
        .background {
            self.background
        }
        .navigationTitle(self.tagDetailVM.tag.label)
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
        .sheet(isPresented: self.$tagDetailVM.showBookmarkCreationSheet) {
            self.bookmarkCreationContent
        }
        .sheet(isPresented: self.$tagDetailVM.showShareSheet) {
            self.shareSheetContent
        }
        .alert(
            self.tagDetailVM.deletingContentLabel,
            isPresented: self.$tagDetailVM.showBookmarkDeleteDialog
        ) {
            self.alertButtons
        }
        .searchable(
            text: self.$searchQuery,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search for bookmarks in \(self.tagDetailVM.tag.label)"
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
        let filteredBookmarks = self.tagDetailVM.onFilterBookmarks(
            bookmarks: self.bookmarks,
            sorting: self.tagDefaultSorting,
            searchQuery: self.searchQuery
        )
        BookmarkListView(
            bookmarks: filteredBookmarks,
            searchQuery: self.searchQuery,
            onPressBookmark: { bookmark in
                self.navigationManager.navigate(to: .bookmark(bookmark: bookmark))
            },
            onShareBookmark: { bookmark in
                self.tagDetailVM.onShowShareSheet(bookmark: bookmark)
            },
            onEditBookmark: { bookmark in
                self.tagDetailVM.onShowBookmarkCreationSheet(bookmark: bookmark)
            },
            onDeleteBookmark: { bookmark in
                self.tagDetailVM.onShowBookmarkDeleteDialog(bookmark: bookmark)
            }
        )
    }
    
    @ViewBuilder
    private var bookmarkCreationContent: some View {
        CreateBookmarkSheetContent(
            bookmark: self.tagDetailVM.selectedBookmark,
            onDismiss: {
                self.tagDetailVM.onCloseBookmarkCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var shareSheetContent: some View {
        if let bookmark = self.tagDetailVM.selectedBookmark {
            if let link = URL(string: bookmark.link) {
                ShareSheet(bookmarkLink: link)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .onDisappear {
                        self.tagDetailVM.onCloseShareSheet()
                    }
            }
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        Button(role: .destructive) {
            if let bookmark = self.tagDetailVM.deletingBookmark {
                self.modelContext.delete(bookmark)
            }
            self.tagDetailVM.onCloseBookmarkDeleteDialog()
        } label: {
            Text("Delete")
        }
        Button(role: .cancel) {
            self.tagDetailVM.onCloseBookmarkDeleteDialog()
        } label: {
            Text("Cancel")
        }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        Menu {
            ForEach(Sorting.allCases, id: \.rawValue) { sorting in
                Button {
                    self.tagDefaultSorting = sorting
                } label: {
                    HStack {
                        Text(sorting.getNaming())
                        Spacer()
                        if sorting == self.tagDefaultSorting {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        } label: {
            Button {
                self.tagDetailVM.showSortingMenu.toggle()
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
            ? self.tagDetailVM.tag.secondaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
            : self.tagDetailVM.tag.primaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
            self.animateGradient
            ? self.tagDetailVM.tag.primaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
            : self.tagDetailVM.tag.secondaryColor.getUIColor()
                .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
        ]
    }
}

#Preview {
    TagDetailScreen(tag: .empty())
}
