//
//  TagsFlowView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI
import Flow

struct TagsFlowView: View {
    let tags: [Tag]
    let noContentMessage: String
    let allowTagAddition: Bool
    let isInPreviewMode: Bool
    let onPressTag: (Tag) -> Void
    let onEditTag: (Tag) -> Void
    let onDeleteTag: (Tag) -> Void
    let onClickTagCreation: (() -> Void)?

    var body: some View {
        if self.tags.isEmpty {
            self.noContentArea
        } else {
            self.tagsArea
        }
    }

    @ViewBuilder
    private var noContentArea: some View {
        VStack {
            ContentUnavailableView {
                Label("No Tags Found", systemImage: "tag")
            } description: {
                Text(self.noContentMessage)
            } actions: {
                if allowTagAddition {
                    DottedTagView(
                        label: "Create Tag",
                        onClicked: {
                            if let onClickCreateTag = self.onClickTagCreation {
                                onClickCreateTag()
                            }
                        }
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var tagsArea: some View {
        HFlow(horizontalAlignment: .center, verticalAlignment: .top) {
            if allowTagAddition {
                DottedTagView(
                    label: "Create Tag",
                    onClicked: {
                        if let onClickCreateTag = self.onClickTagCreation {
                            onClickCreateTag()
                        }
                    }
                )
            }
            ForEach(self.tags) { tag in
                TagView(
                    tag: tag,
                    isInPreviewMode: self.isInPreviewMode,
                    onPressed: {
                        self.onPressTag(tag)
                    },
                    onEditPressed: {
                        if !self.isInPreviewMode {
                            self.onEditTag(tag)
                        }
                    },
                    onDeletePressed: {
                        if !self.isInPreviewMode {
                            self.onDeleteTag(tag)
                        }
                    }
                )
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    TagsFlowView(
        tags: [],
        noContentMessage: "",
        allowTagAddition: false,
        isInPreviewMode: true,
        onPressTag: { _ in },
        onEditTag: { _ in },
        onDeleteTag: { _ in },
        onClickTagCreation: nil
    )
}
