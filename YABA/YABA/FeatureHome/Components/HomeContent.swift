//
//  HomeContent.swift
//  YABA
//
//  Created by Ali Taha on 23.10.2024.
//

import SwiftUI
import SwiftData

struct HomeContent: View {
    @Query(sort: \Folder.createdAt, order: .forward)
    private var folders: [Folder]

    @Query(sort: \Tag.createdAt, order: .forward)
    private var tags: [Tag]
    
    let isTagsExpanded: Bool
    let isFoldersExpanded: Bool
    
    let onExpandTags: () -> Void
    let onExpandFolders: () -> Void
    
    let onClickFolder: (Folder) -> Void
    let onEditFolder: (Folder) -> Void
    let onDeleteFolder: (Folder) -> Void
    
    let onPressTag: (Tag) -> Void
    let onEditTag: (Tag) -> Void
    let onDeleteTag: (Tag) -> Void
    
    var body: some View {
        VStack {
            self.tagsView
            self.foldersView
        }
    }
    
    @ViewBuilder
    private var tagsView: some View {
        self.generateView(
            title: "Tags",
            isExpanded: self.isTagsExpanded,
            onPressExpand: self.onExpandTags
        ) {
            TagsFlowView(
                tags: self.tags,
                noContentMessage: """
    It seems like you have not created any tags yet! Tap the button below to create your first tag.
    """,
                allowTagAddition: false,
                isInPreviewMode: false,
                onPressTag: self.onPressTag,
                onEditTag: self.onEditTag,
                onDeleteTag: self.onDeleteTag,
                onClickTagCreation: nil
            ).transition(.opacity.combined(with: .blurReplace))
        }
    }
    
    @ViewBuilder
    private var foldersView: some View {
        self.generateView(
            title: "Folders",
            isExpanded: self.isFoldersExpanded,
            onPressExpand: self.onExpandFolders
        ) {
            FolderListView(
                folders: self.folders,
                noContentMessage: """
    It seems like you have not created any folder yet! Tap the button below to create your first folder.
    """,
                allowFolderAddition: false,
                isInPreviewMode: false,
                currentSelectedFolder: nil,
                onClickFolder: self.onClickFolder,
                onEditFolder: self.onEditFolder,
                onDeleteFolder: self.onDeleteFolder,
                onClickCreateFolder: nil
            )
            .transition(.opacity.combined(with: .blurReplace))
            Spacer().frame(height: 100)
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func generateView(
        title: String,
        isExpanded: Bool,
        onPressExpand: @escaping () -> Void,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button {
                    onPressExpand()
                } label: {
                    Circle()
                        .fill(.thinMaterial)
                        .frame(width: 35, height: 35, alignment: .center)
                        .overlay {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(isExpanded ? -180 : 0))
                        }
                }.buttonStyle(.plain)
            }
            .padding(.horizontal)
            
            if isExpanded {
                content()
            }
        }
    }
}

#Preview {
    HomeContent(
        isTagsExpanded: true,
        isFoldersExpanded: true,
        onExpandTags: {
            // Do Nothing
        },
        onExpandFolders: {
            // Do Nothing
        },
        onClickFolder: { _ in
            // Do Nothing
        },
        onEditFolder: { _ in
            // Do Nothing
        },
        onDeleteFolder: { _ in
            // Do Nothing
        },
        onPressTag: { _ in
            // Do Nothing
        },
        onEditTag: { _ in
            // Do Nothing
        },
        onDeleteTag: { _ in
            // Do Nothing
        }
    )
}
