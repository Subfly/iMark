//
//  CreateTagSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct CreateTagSheetContent: View {
    @Environment(\.dismiss)
    private var dismiss

    @Environment(NavigationManager.self)
    private var navigationManager

    @Bindable
    var createFolderVM: CreateTagVM = .init()

    var body: some View {
        Text("CreateTagSheetContent")
            .onDisappear {
                navigationManager.onDismissTagCreationSheet()
            }
    }
}

#Preview {
    CreateTagSheetContent()
}
