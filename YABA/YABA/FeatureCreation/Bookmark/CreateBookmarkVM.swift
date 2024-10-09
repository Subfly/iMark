//
//  CreateBookmarkVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class CreateBookmarkVM {
    let labelLimit = 15
    let descriptionLimit = 120

    var linkText: String = ""
    var labelText: String = ""
    var tags: [PersistentIdentifier] = []
    var description: String = ""
    var imageUrl: String = ""
    var folderId: PersistentIdentifier?

    var labelCounterText: String
    var labelHasError: Bool = false

    var descriptionCounterText: String
    var descriptionHasError: Bool = false

    init() {
        self.labelCounterText = "0\\\(labelLimit)"
        self.descriptionCounterText = "0\\\(descriptionLimit)"
    }

    func onChangeLink(_ text: String) {
        // TASK: SEND TO UNFURLING
        self.linkText = text
    }

    func onChaneLabel(_ text: String) {
        if self.labelText.count > self.labelLimit {
            self.labelText = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.labelText.count)\\\(self.labelLimit)"
        self.labelHasError = self.labelText.count == self.labelLimit
    }

    func onChaneDescription(_ text: String) {
        if self.description.count > self.descriptionLimit {
            self.description = String(text.prefix(self.descriptionLimit))
        }
        self.descriptionCounterText = "\(self.description.count)\\\(self.descriptionLimit)"
        self.descriptionHasError = self.labelText.count == self.descriptionLimit
    }
}
