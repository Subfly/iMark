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
                        navigationManager.showBookmarkCreationSheet()
                    case .folder:
                        navigationManager.showFolderCreationSheet()
                    case .tag:
                        navigationManager.showTagCreationSheet()
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
        if self.tags.isEmpty {
            NoContentView(
                iconName: "tag",
                message: "No tags yet. Press + button to create your first folder."
            )
        } else {
            HFlow(horizontalAlignment: .center, verticalAlignment: .top) {
                ForEach(self.tags) { tag in
                    TagView(
                        tag: tag,
                        isInPreviewMode: false,
                        onPressed: {
                            // TASK: NAVIGATE TO TAG DETAIL
                        },
                        onEditPressed: {
                            // TASK: OPEN CREATE SHEET WITH EDIT MODE
                        },
                        onDeletePressed: {
                            self.homeVM.onShowDeleteDailog(tag: tag)
                        }
                    )
                }
            }.frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private var foldersView: some View {
        Text("Folders")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
        if self.folders.isEmpty {
            NoContentView(
                iconName: "folder",
                message: "No folders yet. Press + button to create your first folder."
            )
        } else {
            LazyVGrid(columns: [
                GridItem(),
                GridItem()
            ]) {
                ForEach(self.folders) { folder in
                    FolderView(
                        folder: folder,
                        isInPreviewMode: false,
                        onClickFolder: {
                            // TASK: NAVIGATE TO FOLDER DETAIL
                        },
                        onEditPressed: {
                            // TASK: OPEN CREATE SHEET WITH EDIT MODE
                        },
                        onDeletePressed: {
                            self.homeVM.onShowDeleteDailog(folder: folder)
                        }
                    )
                }
            }.padding(.horizontal)
        }
    }
}
