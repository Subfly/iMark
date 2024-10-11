//
//  HomeScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI
import SwiftData
import Flow

struct HomeScreen: View {
    @Environment(\.modelContext)
    private var modelContext

    @Environment(NavigationManager.self)
    private var navigationManager

    @Bindable
    var homeVM: HomeVM = .init()

    @Query(sort: \Folder.createdAt, order: .forward)
    private var folders: [Folder]

    @Query(sort: \Tag.createdAt, order: .forward)
    private var tags: [Tag]

    var body: some View {
        ZStack {
            ScrollView {
                tagsView
                Spacer().frame(height: 32)
                foldersView
            }
            fabArea
        }
        .navigationTitle("Home")
        .searchable(
            text: self.$homeVM.searchQuery,
            prompt: "Search in Bookmarks..."
        )
        .alert(self.homeVM.deletingContentLabel, isPresented: self.$homeVM.shouldShowDeleteDialog) {
            alertButtons
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
                        self.navigationManager.showBookmarkCreationSheet()
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
            ).padding(.bottom)
        }
    }
    
    @ViewBuilder
    private var tagsView: some View {
        Text("Tags")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
        TagsFlowView(
            tags: self.tags,
            noContentMessage: "No tags yet. Press + button to create your first folder.",
            allowTagAddition: false,
            isInPreviewMode: false,
            onPressTag: { _ in
                // TASK: NAVIGATE TO TAG DETAIL
            },
            onEditTag: { tag in
                self.navigationManager.showTagCreationSheet(tag: tag)
            },
            onDeleteTag: { tag in
                self.homeVM.onShowDeleteDailog(tag: tag)
            },
            onClickTagCreation: nil
        )
    }
    
    @ViewBuilder
    private var foldersView: some View {
        Text("Folders")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
        FolderListView(
            folders: self.folders,
            noContentMessage: "No folders yet. Press + button to create your first folder.",
            allowFolderAddition: false,
            isInPreviewMode: false,
            onClickFolder: { _ in
                // TASK: NAVIGATE TO FOLDER DETAIL
            },
            onEditFolder: { folder in
                self.navigationManager.showFolderCreationSheet(folder: folder)
            },
            onDeleteFolder: { folder in
                self.homeVM.onShowDeleteDailog(folder: folder)
            },
            onClickCreateFolder: nil
        )
    }
}
