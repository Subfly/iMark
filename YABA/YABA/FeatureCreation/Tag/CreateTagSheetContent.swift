//
//  CreateTagSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

struct CreateTagSheetContent: View {
    @Environment(NavigationManager.self)
    private var navigationManager

    @Environment(\.modelContext)
    private var modelContext

    @Bindable
    var createTagVM: CreateTagVM = .init()

    var body: some View {
        NavigationView {
            CreationSheetContentView(onCreateButtonLabel: "Create Tag") {
                let createdTag = self.createTagVM.getTag()
                self.modelContext.insert(createdTag)
                self.navigationManager.onDismissTagCreationSheet()
            } onDismissRequest: {
                self.navigationManager.onDismissTagCreationSheet()
            } content: {
                Form {
                    self.previewSection
                    self.nameSection
                    self.iconSection
                }
            }
            .navigationTitle("Create Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.navigationManager.onDismissTagCreationSheet()
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
        Section("Preview") {
            TagView(
                tag: Tag(
                    label: self.createTagVM.labelText,
                    createdAt: .now,
                    icon: self.createTagVM.selectedIcon
                ),
                isInPreviewMode: true,
                onPressed: {},
                onEditPressed: {},
                onDeletePressed: {}
            )
            .frame(width: 200, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }.listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section {
            TextField(
                "Tag Name",
                text: self.$createTagVM.labelText
            ).onChange(of: self.createTagVM.labelText) { _, newValue in
                self.createTagVM.onChaneLabel(newValue)
            }
        } header: {
            Text("Info")
        } footer: {
            Text(self.createTagVM.labelCounterText)
                .foregroundStyle(self.createTagVM.labelHasError ? .red : .secondary)
        }
    }
    
    @ViewBuilder
    private var iconSection: some View {
        Section {
            EmojiTextField(
                text: self.$createTagVM.selectedIcon,
                placeholder: "Tag Icon"
            ).onChange(of: self.createTagVM.selectedIcon) { _, newValue in
                self.createTagVM.onChangeIcon(newValue)
            }
        } header: {
            Text("Icon")
        }
    }
}

#Preview {
    CreateTagSheetContent()
}
