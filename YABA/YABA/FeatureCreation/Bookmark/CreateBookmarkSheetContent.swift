//
//  CreateBookmarkSheetContent.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

struct CreateBookmarkSheetContent: View {
    @Environment(\.dismiss)
    private var dismiss

    @Environment(NavigationManager.self)
    private var navigationManager

    @Bindable
    var createFolderVM: CreateBookmarkVM = .init()

    var body: some View {
        Text("CreateBookmarkSheetContent")
            .onDisappear {
                navigationManager.onDismissBookmarkCreationSheet()
            }
    }
}

#Preview {
    CreateBookmarkSheetContent()
}
