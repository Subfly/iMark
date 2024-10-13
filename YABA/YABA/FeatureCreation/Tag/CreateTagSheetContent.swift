//
//  CreateTagSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

struct CreateTagSheetContent: View {
    @Environment(\.modelContext)
    private var modelContext

    @State
    var createTagVM: CreateTagVM
    
    let onDismiss: () -> Void
    
    init(
        tag: Tag?,
        onDismiss: @escaping () -> Void
    ) {
        self.createTagVM = .init(tag: tag)
        self.onDismiss = onDismiss
    }

    var body: some View {
        NavigationView {
            CreationSheetContentView(
                buttonLabel: self.createTagVM.isEditMode ? "Edit Tag" : "Create Tag"
            ) {
                // TASK: VALIDATE BEFORE SAVE
                self.modelContext.insert(self.createTagVM.tag)
                self.onDismiss()
            } onDismissRequest: {
                self.onDismiss()
            } content: {
                Form {
                    self.previewSection
                    self.nameSection
                    self.iconSection
                }
            }
            .navigationTitle(self.createTagVM.isEditMode ? "Edit Tag" : "Create Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.onDismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.8)])
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    private var previewSection: some View {
        Section {
            TagView(
                tag: self.createTagVM.tag,
                isInPreviewMode: true,
                onPressed: {},
                onEditPressed: {},
                onDeletePressed: {}
            )
            .frame(width: 200, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        } header: {
            HStack {
                Image(systemName: "rectangle.and.text.magnifyingglass")
                Text("Preview")
            }
        }
        .listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section {
            TextField(
                "Tag Name",
                text: self.$createTagVM.tag.label
            ).onChange(of: self.createTagVM.tag.label) { _, newValue in
                self.createTagVM.onChaneLabel(newValue)
            }
        } header: {
            HStack {
                Image(systemName: "t.square")
                Text("Name")
            }
        } footer: {
            Text(self.createTagVM.labelCounterText)
                .foregroundStyle(self.createTagVM.labelHasError ? .red : .secondary)
        }
    }
    
    @ViewBuilder
    private var iconSection: some View {
        Section {
            EmojiTextField(
                text: self.$createTagVM.tag.icon,
                placeholder: "Tag Icon"
            ).onChange(of: self.createTagVM.tag.icon) { _, newValue in
                self.createTagVM.onChangeIcon(newValue)
            }
        } header: {
            HStack {
                Image(systemName: "app")
                Text("Icon")
            }
        }
    }
}

#Preview {
    CreateTagSheetContent(
        tag: .empty(),
        onDismiss: {}
    )
}
