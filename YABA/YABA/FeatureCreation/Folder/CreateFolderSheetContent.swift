//
//  CreateFolderSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateFolderSheetContent: View {
    @Environment(\.modelContext)
    private var modelContext

    @State
    private var createFolderVM: CreateFolderVM

    let onDismiss: () -> Void
    let onCreationCallback: ((Folder) -> Void)?
    
    init(
        folder: Folder?,
        onDismiss: @escaping () -> Void,
        onCreationCallback: ((Folder) -> Void)? = nil
    ) {
        self.createFolderVM = .init(folder: folder)
        self.onDismiss = onDismiss
        self.onCreationCallback = onCreationCallback
    }

    var body: some View {
        NavigationView {
            CreationSheetContentView(
                buttonLabel: self.createFolderVM.isEditMode ? "Edit Folder" : "Create Folder",
                hasError: self.createFolderVM.validationError
            ) {
                self.onCreateFolder()
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
            .navigationTitle(self.createFolderVM.isEditMode ? "Edit Folder" : "Create Folder")
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
        .sheet(isPresented: self.$createFolderVM.showPrimaryColorPicker) {
            self.generateColorSelectionPicker(
                selection: self.$createFolderVM.folder.primaryColor,
                onDismiss: {
                    self.createFolderVM.onClosePrimaryColorPicker()
                }
            )
        }
        .sheet(isPresented: self.$createFolderVM.showSecondaryColorPicker) {
            self.generateColorSelectionPicker(
                selection: self.$createFolderVM.folder.secondaryColor,
                onDismiss: {
                    self.createFolderVM.onCloseSecondaryColorPicker()
                }
            )
        }
    }
    
    @ViewBuilder
    private var previewSection: some View {
        Section {
            FolderView(
                folder: self.createFolderVM.folder,
                isInPreviewMode: true,
                isSelected: false,
                onClickFolder: {},
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
                "Folder Name",
                text: self.$createFolderVM.folder.label
            ).onChange(of: self.createFolderVM.folder.label) { _, newValue in
                self.createFolderVM.onChaneLabel(newValue)
            }
        } header: {
            HStack {
                Image(systemName: "t.square")
                Text("Name")
            }.foregroundStyle(self.createFolderVM.labelHasError ? .red : .secondary)
        } footer: {
            HStack {
                if self.createFolderVM.labelHasError {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                Text(self.createFolderVM.labelCounterText)
            }.foregroundStyle(self.createFolderVM.labelHasError ? .red : .secondary)
        }
    }
    
    @ViewBuilder
    private var iconSection: some View {
        Section {
            EmojiTextField(
                text: self.$createFolderVM.folder.icon,
                placeholder: "Folder Icon"
            ).onChange(of: self.createFolderVM.folder.icon) { _, newValue in
                self.createFolderVM.onChangeIcon(newValue)
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
                color: self.createFolderVM.folder.primaryColor
            )
            .onTapGesture {
                self.createFolderVM.onShowPrimaryColorPicker()
            }
            self.generateColorSelectionTile(
                label: "Secondary Color",
                color: self.createFolderVM.folder.secondaryColor
            )
            .onTapGesture {
                self.createFolderVM.onShowSecondaryColorPicker()
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
    
    private func onCreateFolder() {
        if self.createFolderVM.validate() {
            Task {
                self.modelContext.insert(self.createFolderVM.folder)
                try? await Task.sleep(for: .milliseconds(1))
                try? self.modelContext.save()
                if let callback = self.onCreationCallback {
                    callback(self.createFolderVM.folder)
                }
                self.onDismiss()
            }
        }
    }
}

#Preview {
    CreateFolderSheetContent(
        folder: .empty(),
        onDismiss: {}
    )
}
