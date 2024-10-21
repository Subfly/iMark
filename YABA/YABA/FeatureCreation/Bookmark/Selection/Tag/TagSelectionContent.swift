//
//  CreateBookmarkTagSelectionPopoverContent.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI
import SwiftData

struct TagSelectionContent: View {
    @Environment(CreateBookmarkNavigationManager.self)
    private var createBookmarkNavigationManager
    
    @Query(sort: \Tag.createdAt, order: .forward)
    private var tags: [Tag]
    
    @State
    private var showTagCreationSheet: Bool = false
    
    @State
    private var selectedTags: [Tag]
    
    let onDoneSelectionCallback: ([Tag]) -> Void
    
    init(
        selectedTags: [Tag],
        onDoneSelectionCallback: @escaping ([Tag]) -> Void
    ) {
        self.selectedTags = selectedTags
        self.onDoneSelectionCallback = onDoneSelectionCallback
    }
    
    var body: some View {
        ScrollView {
            self.createTagFlowView(
                tags: self.selectedTags,
                label: "Selected Tags",
                isSelectables: false
            )
            .padding(.bottom, 32)
            self.createTagFlowView(
                tags: self.tags.filter { tag in
                    !self.selectedTags.contains(tag)
                },
                label: "Selectable Tags",
                isSelectables: true
            )
        }
        .navigationTitle("Select Tags")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.createBookmarkNavigationManager.pop()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.createBookmarkNavigationManager.pop()
                    self.onDoneSelectionCallback(self.selectedTags)
                } label: {
                    Text("Done")
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    @ViewBuilder
    private func createTagFlowView(
        tags: [Tag],
        label: String,
        isSelectables: Bool
    ) -> some View {
        VStack {
            Text(label)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
             TagsFlowView(
                 tags: tags,
                 noContentMessage: isSelectables
                 ? """
It seems like you have not created any tag yet! Tap the button below to create your first tag.
"""
                 : "No tags selected, tap one of them below to select",
                 allowTagAddition: isSelectables,
                 isInPreviewMode: true,
                 onPressTag: { tag in
                     withAnimation {
                         if self.selectedTags.contains(tag) {
                             self.selectedTags.removeAll {
                                 $0.persistentModelID == tag.persistentModelID
                             }
                         } else {
                             self.selectedTags.append(tag)
                         }
                     }
                 },
                 onEditTag: { _ in
                     /* Do Nothing */
                 },
                 onDeleteTag: { _ in
                     /* Do Nothing */
                 },
                 onClickTagCreation: {
                     withAnimation { self.showTagCreationSheet = true }
                 }
             )
             .transition(.scale.combined(with: .opacity.combined(with: .blurReplace)))
             .animation(.bouncy, value: tags)
        }.padding(.horizontal)
    }
}

#Preview {
    TagSelectionContent(
        selectedTags: [],
        onDoneSelectionCallback: { _ in
            // Do Nothing...
        }
    )
}
