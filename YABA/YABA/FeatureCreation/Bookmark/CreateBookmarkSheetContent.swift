//
//  CreateBookmarkSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateBookmarkSheetContent: View {
    @Environment(NavigationManager.self)
    private var navigationManager

    @Environment(\.modelContext)
    private var modelContext

    @Bindable
    var createBookmarkVM: CreateBookmarkVM = .init()

    var body: some View {
        NavigationView {
            CreationSheetContentView(onCreateButtonLabel: "Create Bookmark") {
                // TASK: ADD FUNCTIONALITY
                self.navigationManager.onDismissBookmarkCreationSheet()
            } onDismissRequest: {
                self.navigationManager.onDismissBookmarkCreationSheet()
            } content: {
                Form {
                    self.previewSection
                    self.linkSection
                    self.nameSection
                    self.descriptionSection
                }
            }
            .navigationTitle("Create Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.navigationManager.onDismissBookmarkCreationSheet()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    private var previewSection: some View {
        Section("Preview") {
            BookmarkView(
                bookmark: Bookmark(
                    link: self.createBookmarkVM.linkText,
                    label: self.createBookmarkVM.labelText,
                    createdAt: .now,
                    tags: [],
                    bookmarkDescription: self.createBookmarkVM.description
                ),
                isInPreviewMode: true,
                onPressed: {},
                onEditPressed: {},
                onDeletePressed: {}
            )
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 90, alignment: .center)
            .background {
                Color.secondary.opacity(0.5).clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }.listRowBackground(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var linkSection: some View {
        Section("Link") {
            TextField(
                "Bookmark Link",
                text: self.$createBookmarkVM.linkText
            ).onChange(of: self.createBookmarkVM.linkText) { _, newValue in
                self.createBookmarkVM.onChangeLink(newValue)
            }
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section {
            TextField(
                "Bookmark Title",
                text: self.$createBookmarkVM.labelText
            ).onChange(of: self.createBookmarkVM.labelText) { _, newValue in
                self.createBookmarkVM.onChaneLabel(newValue)
            }
        } header: {
            Text("Title")
        } footer: {
            Text(self.createBookmarkVM.labelCounterText)
                .foregroundStyle(self.createBookmarkVM.labelHasError ? .red : .secondary)
        }
    }
    
    @ViewBuilder
    private var descriptionSection: some View {
        Section {
            TextField(
                "Bookmark Description",
                text: self.$createBookmarkVM.description,
                axis: .vertical
            )
            .lineLimit(2...5)
            .onChange(of: self.createBookmarkVM.description) { _, newValue in
                self.createBookmarkVM.onChaneDescription(newValue)
            }
        } header: {
            Text("Description")
        } footer: {
            Text(self.createBookmarkVM.descriptionCounterText)
                .foregroundStyle(self.createBookmarkVM.descriptionHasError ? .red : .secondary)
        }
    }
}

#Preview {
    CreateBookmarkSheetContent()
}
