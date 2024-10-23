//
//  HomeScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//
// swiftlint:disable all

import SwiftUI
import SwiftData
import Flow

struct HomeScreen: View {
    @AppStorage("tagsOpen")
    private var isTagsContentOpen: Bool = false
    
    @AppStorage("foldersOpen")
    private var isFoldersContentOpen: Bool = true
    
    @Environment(\.modelContext)
    private var modelContext

    @Environment(NavigationManager.self)
    private var navigationManager

    @FocusState
    private var isSearching: Bool

    @State
    private var homeVM: HomeVM = .init()
    
    @State
    private var searchQuery: String = ""
    
    @Query(sort: \Bookmark.createdAt, order: .forward)
    private var bookmarks: [Bookmark]

    var body: some View {
        self.viewSwitcher
            .navigationTitle("Home")
            .toolbar {
                Button {
                    self.navigationManager.navigate(to: .settings)
                } label: {
                    Image(systemName: "gearshape")
                }
            }
            .searchable(
                text: self.$searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search in Bookmarks..."
            )
            .searchFocused(self.$isSearching)
            .sheet(isPresented: self.$homeVM.showShareSheet) {
                self.shareSheetContent
            }
            .alert(self.homeVM.deletingContentLabel, isPresented: self.$homeVM.shouldShowDeleteDialog) {
                self.alertButtons
            }
    }
    
    @ViewBuilder
    private var viewSwitcher: some View {
        if self.isSearching {
            self.searchView
        } else {
            ZStack {
                ScrollView {
                    self.homeContent
                }
                self.fabArea.ignoresSafeArea()
            }
            .animation(.easeInOut, value: self.isTagsContentOpen)
            .animation(.easeInOut, value: self.isFoldersContentOpen)
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        Button(role: .destructive) {
            Task {
                if let folder = self.homeVM.deletingFolder {
                    self.modelContext.delete(folder)
                    try? await Task.sleep(for: .milliseconds(1))
                }
                if let tag = self.homeVM.deletingTag {
                    self.modelContext.delete(tag)
                    try? await Task.sleep(for: .milliseconds(1))
                }
                if let bookmark = self.homeVM.deletingBookmark {
                    self.modelContext.delete(bookmark)
                    try? await Task.sleep(for: .milliseconds(1))
                }
                try? self.modelContext.save()
                self.homeVM.onCloseDialog()
            }
        } label: {
            Text("Delete")
        }
        Button(role: .cancel) {
            self.homeVM.onCloseDialog()
        } label: {
            Text("Cancel")
        }
    }
    
    @ViewBuilder
    private var fabArea: some View {
        VStack {
            Spacer()
            CreateContentFAB(
                isActive: self.homeVM.shouldShowMiniButtons,
                onClickAction: { type in
                    switch type {
                    case .bookmark:
                        self.navigationManager.showBookmarkCreationSheet(bookmark: nil)
                    case .folder:
                        self.navigationManager.showFolderCreationSheet(folder: nil)
                    case .tag:
                        self.navigationManager.showTagCreationSheet(tag: nil)
                    case .main:
                        withAnimation {
                            self.homeVM.toggleCreateMenu()
                        }
                    }
                },
                onDismissRequest: {
                    withAnimation {
                        self.homeVM.toggleCreateMenu()
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    private var homeContent: some View {
        HomeContent(
            isTagsExpanded: self.isTagsContentOpen,
            isFoldersExpanded: self.isFoldersContentOpen,
            onExpandTags: {
                withAnimation {
                    self.isTagsContentOpen.toggle()
                }
            },
            onExpandFolders: {
                withAnimation {
                    self.isFoldersContentOpen.toggle()
                }
            },
            onClickFolder: { folder in
                self.navigationManager.navigate(to: .folder(folder: folder))
            },
            onEditFolder: { folder in
                self.navigationManager.showFolderCreationSheet(folder: folder)
            },
            onDeleteFolder: { folder in
                self.homeVM.onShowDeleteDailog(folder: folder)
            },
            onPressTag: { tag in
                self.navigationManager.navigate(to: .tag(tag: tag))
            },
            onEditTag: { tag in
                self.navigationManager.showTagCreationSheet(tag: tag)
            },
            onDeleteTag: { tag in
                self.homeVM.onShowDeleteDailog(tag: tag)
            }
        )
    }
    
    @ViewBuilder
    private var searchView: some View {
        List {
            BookmarkListView(
                bookmarks: self.homeVM.onFilterBookmarks(
                    bookmarks: self.bookmarks,
                    searchQuery: self.searchQuery
                ),
                searchQuery: self.searchQuery,
                onPressBookmark: { bookmark in
                    self.navigationManager.navigate(to: .bookmark(bookmark: bookmark))
                },
                onShareBookmark: { bookmark in
                    self.homeVM.onShowShareSheet(bookmark: bookmark)
                },
                onEditBookmark: { bookmark in
                    self.navigationManager.showBookmarkCreationSheet(bookmark: bookmark)
                },
                onDeleteBookmark: { bookmark in
                    self.homeVM.onShowDeleteDialog(bookmark: bookmark)
                }
            )
        }
    }
    
    @ViewBuilder
    private var shareSheetContent: some View {
        if let bookmark = self.homeVM.selectedBookmark {
            if let link = URL(string: bookmark.link) {
                ShareSheet(bookmarkLink: link)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .onDisappear {
                        self.homeVM.onCloseShareSheet()
                    }
            }
        }
    }
}
