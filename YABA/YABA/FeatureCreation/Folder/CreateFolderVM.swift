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
    let isEditMode: Bool
    let labelLimit = 15
    let iconLimit = 1

    var labelCounterText: String
    var labelHasError: Bool = false
    
    var folder: Folder

    init(folder: Folder?) {
        self.labelCounterText = "0\\\(labelLimit)"
        self.folder = folder ?? .empty()
        self.isEditMode = folder != nil
    }

    func onChaneLabel(_ text: String) {
        if self.folder.label.count > self.labelLimit {
            self.folder.label = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.folder.label.count)\\\(self.labelLimit)"
        self.labelHasError = self.folder.label.count == self.labelLimit
    }

    func onChangeIcon(_ icon: String) {
        if self.folder.icon.count > self.iconLimit {
            self.folder.icon = String(icon.suffix(iconLimit))
        }
    }
}
