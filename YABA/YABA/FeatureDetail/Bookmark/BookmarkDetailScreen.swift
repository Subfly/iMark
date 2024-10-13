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

    @Environment(\.colorScheme)
    private var colorScheme
    
    @State
    private var bookmarkDetailVM: BookmarkDetailVM

    @State
    private var animateGradient: Bool = false
    
    init(bookmark: Bookmark) {
        self.bookmarkDetailVM = .init(bookmark: bookmark)
    }
    
    var body: some View {
        List {
            self.linkSection
            self.infoSection
            self.tagsSection
        }
        .scrollContentBackground(.hidden)
        .background {
            self.background
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
        BookmarkDetailInfoSection(
            bookmark: self.bookmarkDetailVM.bookmark,
            onClickFolder: { folder in
                self.navigationManager.navigate(to: .folder(folder: folder))
            }
        )
    }
    
    @ViewBuilder
    private var tagsSection: some View {
        BookmarkDetailTagsSection(
            tags: self.bookmarkDetailVM.bookmark.tags,
            onClickTag: { tag in
                self.navigationManager.navigate(to: .tag(tag: tag))
            }
        )
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        BookmarkDetailContextMenu(
            onShowShareSheet: {
                self.bookmarkDetailVM.onShowShareSheet()
            },
            onRefreshBookmark: {
                Task {
                    await self.bookmarkDetailVM.onRefreshBookmark()
                    self.modelContext.insert(self.bookmarkDetailVM.bookmark)
                }
            },
            onShowBookmarkDeleteDialog: {
                self.bookmarkDetailVM.onShowBookmarkDeleteDialog()
            }
        )
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
    
    private func getBackgroundGradientColors() -> [Color] {
        var base = [
            Color(UIColor.systemBackground),
            Color(UIColor.systemBackground),
        ]

        if let folder = self.bookmarkDetailVM.bookmark.folder {
            base.append(
                contentsOf: [
                    self.animateGradient
                    ? folder.secondaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
                    : folder.primaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
                    self.animateGradient
                    ? folder.primaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
                    : folder.secondaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
                ]
            )
        }
        
        for tag in self.bookmarkDetailVM.bookmark.tags {
            base.append(
                contentsOf: [
                    self.animateGradient
                    ? tag.secondaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
                    : tag.primaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
                    self.animateGradient
                    ? tag.primaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2)
                    : tag.secondaryColor.getUIColor()
                        .opacity(self.colorScheme == .dark ? 0.2 : 0.2),
                ]
            )
        }

        return base
    }
}
