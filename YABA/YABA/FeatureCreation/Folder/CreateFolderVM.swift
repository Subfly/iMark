//
//  CreateFolderVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

@Observable
class CreateFolderVM {
    let labelLimit = 15
    let iconLimit = 1

    var labelText: String = ""
    var labelCounterText: String
    var labelHasError: Bool = false

    var selectedIcon: String = ""

    init() {
        self.labelCounterText = "0\\\(labelLimit)"
    }

    func onChaneLabel(_ text: String) {
        if self.labelText.count > self.labelLimit {
            self.labelText = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.labelText.count)\\\(self.labelLimit)"
        self.labelHasError = self.labelText.count == self.labelLimit
    }

    func onChangeIcon(_ icon: String) {
        if self.selectedIcon.count > self.iconLimit {
            self.selectedIcon = String(icon.suffix(iconLimit))
        }
    }

    func getFolder() -> Folder {
        Folder(
            label: self.labelText,
            createdAt: .now,
            bookmarks: [],
            icon: self.selectedIcon
        )
    }
}
