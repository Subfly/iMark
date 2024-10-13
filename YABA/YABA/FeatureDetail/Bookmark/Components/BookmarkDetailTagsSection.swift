//
//  BookmarkDetailTagsSection.swift
//  YABA
//
//  Created by Ali Taha on 13.10.2024.
//

import SwiftUI

struct BookmarkDetailTagsSection: View {
    let tags: [Tag]
    let onClickTag: (Tag) -> Void

    var body: some View {
        Section {
            TagsFlowView(
                tags: self.tags,
                noContentMessage:
                    "No tags are added to this bookmark yet. You can add some by editing the bookmark.",
                allowTagAddition: false,
                isInPreviewMode: true,
                onPressTag: { tag in
                    self.onClickTag(tag)
                },
                onEditTag: { _ in
                    /* Do Nothing */
                },
                onDeleteTag: { _ in
                    /* Do Nothing */
                },
                onClickTagCreation: {
                    /* Do Nothing */
                }
            )
        } header: {
            HStack {
                Image(systemName: "tag")
                Text("Tags")
            }
        }
    }
}

#Preview {
    BookmarkDetailTagsSection(
        tags: [],
        onClickTag: { _ in }
    )
}
