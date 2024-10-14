//
//  CreateBookmarkTagSelectionPopoverContent.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct CreateBookmarkTagSelectionPopoverContent: View {
    let selectedTags: [Tag]
    let tags: [Tag]
    let onPressTag: (Tag) -> Void
    let onPressTagCreation: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.onDismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
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
                     self.onPressTag(tag)
                 },
                 onEditTag: { _ in
                     /* Do Nothing */
                 },
                 onDeleteTag: { _ in
                     /* Do Nothing */
                 },
                 onClickTagCreation: {
                     self.onPressTagCreation()
                 }
             )
        }.padding(.horizontal)
    }
}

#Preview {
    CreateBookmarkTagSelectionPopoverContent(
        selectedTags: [],
        tags: [],
        onPressTag: { _ in },
        onPressTagCreation: {},
        onDismiss: {}
    )
}
