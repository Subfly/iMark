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
    private var isTagsContentOpen: Bool = true
    
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

    @Query(sort: \Folder.createdAt, order: .forward)
    private var folders: [Folder]

    @Query(sort: \Tag.createdAt, order: .forward)
    private var tags: [Tag]

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
                    self.tagsView
                    Spacer().frame(height: 32)
                    self.foldersView
                }
                self.fabArea
            }
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        Button(role: .destructive) {
            if let folder = self.homeVM.deletingFolder {
                self.modelContext.delete(folder)
            }
            if let tag = self.homeVM.deletingTag {
                self.modelContext.delete(tag)
            }
            if let bookmark = self.homeVM.deletingBookmark {
                self.modelContext.delete(bookmark)
            }
            self.homeVM.onCloseDialog()
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
    private var tagsView: some View {
        VStack {
            HStack {
                Text("Tags")
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button {
                    withAnimation {
                        self.isTagsContentOpen.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(self.isTagsContentOpen ? -180 : 0))
                }.buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            if self.isTagsContentOpen {
                TagsFlowView(
                    tags: self.tags,
                    noContentMessage: """
        It seems like you have not created any tags yet! Tap the button below to create your first tag.
        """,
                    allowTagAddition: false,
                    isInPreviewMode: false,
                    onPressTag: { tag in
                        self.navigationManager.navigate(to: .tag(tag: tag))
                    },
                    onEditTag: { tag in
                        self.navigationManager.showTagCreationSheet(tag: tag)
                    },
                    onDeleteTag: { tag in
                        self.homeVM.onShowDeleteDailog(tag: tag)
                    },
                    onClickTagCreation: nil
                )
                .transition(.slide)
            }
        }
    }
    
    @ViewBuilder
    private var foldersView: some View {
        HStack {
            Text("Folders")
                .font(.title2)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Button {
                withAnimation {
                    self.isFoldersContentOpen.toggle()
                }
            } label: {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(self.isFoldersContentOpen ? -180 : 0))
            }.buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.bottom)
        if self.isFoldersContentOpen {
            FolderListView(
                folders: self.folders,
                noContentMessage: """
    It seems like you have not created any folder yet! Tap the button below to create your first folder.
    """,
                allowFolderAddition: false,
                isInPreviewMode: false,
                onClickFolder: { folder in
                    self.navigationManager.navigate(to: .folder(folder: folder))
                },
                onEditFolder: { folder in
                    self.navigationManager.showFolderCreationSheet(folder: folder)
                },
                onDeleteFolder: { folder in
                    self.homeVM.onShowDeleteDailog(folder: folder)
                },
                onClickCreateFolder: nil
            )
            .animation(.bouncy, value: self.isFoldersContentOpen)
            .transition(.slide)
            Spacer().frame(height: 120)
        }
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
