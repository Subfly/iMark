//
//  CreateBookmarkTagSelectionView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct CreateBookmarkTagSelectionView: View {
    let tags: [Tag]
    let onPressTag: () -> Void
    
    var body: some View {
        Section {
            self.dynamicTagSelectionView
        } header: {
            HStack {
                Image(systemName: "tag")
                Text("Tags")
            }
        }
        .listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var dynamicTagSelectionView: some View {
        if self.tags.isEmpty {
            DottedTagView(
                label: "Select tags",
                onClicked: {
                    self.onPressTag()
                }
            )
            .frame(width: 200, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        } else {
            TagsFlowView(
                tags: self.tags,
                noContentMessage: "",
                allowTagAddition: true,
                isInPreviewMode: true,
                onPressTag: { _ in
                    self.onPressTag()
                },
                onEditTag: { _ in },
                onDeleteTag: { _ in },
                onClickTagCreation: {
                    self.onPressTag()
                }
            )
        }
    }
}

#Preview {
    CreateBookmarkTagSelectionView(
        tags: [],
        onPressTag: {}
    )
}
