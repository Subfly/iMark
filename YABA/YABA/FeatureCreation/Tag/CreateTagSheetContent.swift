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
                buttonLabel: self.createTagVM.isEditMode ? "Edit Tag" : "Create Tag",
                hasError: self.createTagVM.validationError
            ) {
                if self.createTagVM.validate() {
                    self.modelContext.insert(self.createTagVM.tag)
                    self.onDismiss()
                }
            } onDismissRequest: {
                self.onDismiss()
            } content: {
                Form {
                    self.previewSection
                    self.nameSection
                    self.iconSection
                    self.colorSelectionSection
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
        .presentationDragIndicator(.visible)
        .sheet(isPresented: self.$createTagVM.showPrimaryColorPicker) {
            self.generateColorSelectionPicker(
                selection: self.$createTagVM.tag.primaryColor,
                onDismiss: {
                    self.createTagVM.onClosePrimaryColorPicker()
                }
            )
        }
        .sheet(isPresented: self.$createTagVM.showSecondaryColorPicker) {
            self.generateColorSelectionPicker(
                selection: self.$createTagVM.tag.secondaryColor,
                onDismiss: {
                    self.createTagVM.onCloseSecondaryColorPicker()
                }
            )
        }
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
            }.foregroundStyle(self.createTagVM.labelHasError ? .red : .secondary)
        } footer: {
            HStack {
                if self.createTagVM.labelHasError {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                Text(self.createTagVM.labelCounterText)
            }.foregroundStyle(self.createTagVM.labelHasError ? .red : .secondary)
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
    
    @ViewBuilder
    private var colorSelectionSection: some View {
        Section {
            self.generateColorSelectionTile(
                label: "Primary Color",
                color: self.createTagVM.tag.primaryColor
            )
            .onTapGesture {
                self.createTagVM.onShowPrimaryColorPicker()
            }
            self.generateColorSelectionTile(
                label: "Secondary Color",
                color: self.createTagVM.tag.secondaryColor
            )
            .onTapGesture {
                self.createTagVM.onShowSecondaryColorPicker()
            }
        } header: {
            HStack {
                Image(systemName: "paintpalette")
                Text("Color")
            }
        }
    }
    
    @ViewBuilder
    private func generateColorSelectionTile(label: String, color: YabaColor) -> some View {
        HStack {
            Text(label)
            Spacer()
            HStack(spacing: 8) {
                HStack {
                    Circle()
                        .foregroundStyle(color.getUIColor())
                        .frame(width: 12, height: 12, alignment: .center)
                    Text(color.getUIText())
                }
                Image(systemName: "chevron.right")
            }
        }
    }
    
    @ViewBuilder
    private func generateColorSelectionPicker(
        selection: Binding<YabaColor>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        NavigationView {
            Picker(
                selection: selection,
                content: {
                    ForEach(YabaColor.allCases, id: \.self) { color in
                        HStack {
                            Circle()
                                .foregroundStyle(color.getUIColor())
                                .frame(width: 12, height: 12, alignment: .center)
                            Text(color.getUIText())
                        }
                    }
                },
                label: {
                    Label {
                        Text("Select a color")
                    } icon: {
                        Image(systemName: "paintpalette")
                    }
                }
            )
            .pickerStyle(.wheel)
            .navigationTitle("Select a color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    onDismiss()
                } label: {
                    Text("Done")
                }
            }
            .onDisappear {
                onDismiss()
            }
        }
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CreateTagSheetContent(
        tag: .empty(),
        onDismiss: {}
    )
}
