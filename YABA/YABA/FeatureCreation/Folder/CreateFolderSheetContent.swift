//
//  CreateFolderSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

struct CreateFolderSheetContent: View {
    @Environment(\.dismiss)
    private var dismiss

    @Environment(NavigationManager.self)
    private var navigationManager

    @Bindable
    var createFolderVM: CreateFolderVM = .init()

    var body: some View {
        Text("CreateFolderSheetContent")
            .onDisappear {
                navigationManager.onDismissFolderCreationSheet()
            }
    }
}

#Preview {
    CreateFolderSheetContent()
}
