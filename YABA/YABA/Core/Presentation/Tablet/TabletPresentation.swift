//
//  TabletPresentation.swift
//  YABA
//
//  Created by Ali Taha on 23.10.2024.
//
//  swiftlint:disable all

import SwiftUI
import SwiftData

struct TabletPresentation: View {
    @AppStorage("tagsOpen")
    private var isTagsContentOpen: Bool = false
    
    @AppStorage("foldersOpen")
    private var isFoldersContentOpen: Bool = true
    
    @AppStorage("notPassedOnboarding")
    private var notPassedOnboarding: Bool = true
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(sort: \Folder.createdAt, order: .forward)
    private var folders: [Folder]

    @Query(sort: \Tag.createdAt, order: .forward)
    private var tags: [Tag]

    @State
    private var navigationManager: NavigationManager = .init()
    
    @State
    private var tabletPresentationVM: TabletPresentationVM = .init()
    
    var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: self.$tabletPresentationVM.visibility) {
                self.sidebar
            } content: {
                self.generateContent(
                    selectedTag: self.tabletPresentationVM.selectedTag,
                    selectedFolder: self.tabletPresentationVM.selectedFolder
                ).transition(.blurReplace.combined(with: .opacity))
            } detail: {
                self.detail
            }
            .animation(.smooth, value: self.tabletPresentationVM.selectedFolder)
            .animation(.smooth, value: self.tabletPresentationVM.selectedTag)
            .animation(.smooth, value: self.tabletPresentationVM.selectedBookmark)
            self.fabArea.ignoresSafeArea()
        }
        .sheet(isPresented: self.$navigationManager.createBookmarkSheetActive) {
            self.createBookmarkSheetContent
                .presentationSizing(.page)
        }
        .sheet(isPresented: self.$navigationManager.createFolderSheetActive) {
            self.createFolderSheetContent
                .presentationSizing(.page)
        }
        .sheet(isPresented: self.$navigationManager.createTagSheetActive) {
            self.createTagSheetContent
                .presentationSizing(.page)
        }
        .fullScreenCover(isPresented: self.$notPassedOnboarding) {
            self.onboardingPopoverContent
        }
        .alert(
            self.tabletPresentationVM.deletingContentLabel,
            isPresented: self.$tabletPresentationVM.shouldShowDeleteDialog
        ) {
            self.alertButtons
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        ScrollView {
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
                    self.tabletPresentationVM.onSelectFolder(folder: folder)
                },
                onEditFolder: { folder in
                    self.navigationManager.showFolderCreationSheet(folder: folder)
                },
                onDeleteFolder: { folder in
                    self.tabletPresentationVM.onShowDeleteDailog(folder: folder)
                },
                onPressTag: { tag in
                    self.tabletPresentationVM.onSelectTag(tag: tag)
                },
                onEditTag: { tag in
                    self.navigationManager.showTagCreationSheet(tag: tag)
                },
                onDeleteTag: { tag in
                    self.tabletPresentationVM.onShowDeleteDailog(tag: tag)
                }
            )
            .animation(.easeInOut, value: self.isTagsContentOpen)
            .animation(.easeInOut, value: self.isFoldersContentOpen)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TASK: Open Settings
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
    
    @ViewBuilder
    private func generateContent(
        selectedTag: Tag?,
        selectedFolder: Folder?
    ) -> some View {
        if let tag = selectedTag {
            TagDetailContent(
                tag: tag,
                onAddBookmark: {
                    self.navigationManager.showBookmarkCreationSheet(bookmark: nil)
                },
                onSelectBookmark: { bookmark in
                    self.tabletPresentationVM.onSelectBookmark(bookmark: bookmark)
                }
            )
        } else if let folder = selectedFolder {
            FolderDetailContent(
                folder: folder,
                onAddBookmark: {
                    self.navigationManager.showBookmarkCreationSheet(bookmark: nil)
                },
                onSelectBookmark: { bookmark in
                    self.tabletPresentationVM.onSelectBookmark(bookmark: bookmark)
                }
            )
        } else {
            ContentUnavailableView(
                "Nothing Selected",
                systemImage: "rectangle.grid.1x2",
                description: Text("Select a folder or a tag to see your bookmarks")
            )
        }
    }
    
    @ViewBuilder
    private var detail: some View {
        if let selectedBookmark = self.tabletPresentationVM.selectedBookmark {
            BookmarkDetailContent(
                bookmark: selectedBookmark,
                onSelectFolder: { folder in
                    self.tabletPresentationVM.onSelectFolder(folder: folder)
                },
                onSelectTag: { tag in
                    self.tabletPresentationVM.onSelectTag(tag: tag)
                },
                onCloseBookmarkDetail: {
                    self.tabletPresentationVM.onBookmarkDeletedInDetail()
                }
            )
        } else {
            ContentUnavailableView(
                "No Bookmark Selected",
                systemImage: "bookmark",
                description: Text("Select a bookmark to see details")
            )
        }
    }

    @ViewBuilder
    private var alertButtons: some View {
        Button(role: .destructive) {
            Task {
                if let folder = self.tabletPresentationVM.deletingFolder {
                    self.modelContext.delete(folder)
                    try? await Task.sleep(for: .milliseconds(1))
                }
                if let tag = self.tabletPresentationVM.deletingTag {
                    self.modelContext.delete(tag)
                    try? await Task.sleep(for: .milliseconds(1))
                }
                if let bookmark = self.tabletPresentationVM.deletingBookmark {
                    self.modelContext.delete(bookmark)
                    try? await Task.sleep(for: .milliseconds(1))
                }
                try? self.modelContext.save()
                self.tabletPresentationVM.onCloseDialog()
            }
        } label: {
            Text("Delete")
        }
        Button(role: .cancel) {
            self.tabletPresentationVM.onCloseDialog()
        } label: {
            Text("Cancel")
        }
    }
    
    
    @ViewBuilder
    private var fabArea: some View {
        VStack {
            Spacer()
            CreateContentFAB(
                isActive: self.tabletPresentationVM.shouldShowMiniButtons,
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
                            self.tabletPresentationVM.toggleCreateMenu()
                        }
                    }
                },
                onDismissRequest: {
                    withAnimation {
                        self.tabletPresentationVM.toggleCreateMenu()
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    private var createBookmarkSheetContent: some View {
        CreateBookmarkSheetContent(
            bookmark: self.navigationManager.selectedBookmark,
            onDismiss: {
                self.navigationManager.onDismissBookmarkCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var createFolderSheetContent: some View {
        CreateFolderSheetContent(
            folder: self.navigationManager.selectedFolder,
            onDismiss: {
                self.navigationManager.onDismissFolderCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var createTagSheetContent: some View {
        CreateTagSheetContent(
            tag: self.navigationManager.selectedTag,
            onDismiss: {
                self.navigationManager.onDismissTagCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var onboardingPopoverContent: some View {
        OnboardingView(
            onEndOnboarding: {
                self.notPassedOnboarding = false
            }
        )
        .padding(.vertical, 256)
        .padding(.horizontal, 128)
    }
}

#Preview {
    TabletPresentation()
}
