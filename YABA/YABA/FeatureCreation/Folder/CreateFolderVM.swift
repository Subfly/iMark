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
    let labelLimit = 20
    let iconLimit = 1

    var labelCounterText: String
    var labelHasError: Bool = false
    
    var showPrimaryColorPicker: Bool = false
    var showSecondaryColorPicker: Bool = false

    var validationError: Bool = false
    
    var folder: Folder

    init(folder: Folder?) {
        let labelSize = folder?.label.count ?? 0
        self.labelCounterText = "\(labelSize)\\\(labelLimit)"
        self.folder = folder ?? .empty()
        self.isEditMode = folder != nil
    }

    func onChaneLabel(_ text: String) {
        if self.folder.label.count > self.labelLimit {
            self.folder.label = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.folder.label.count)\\\(self.labelLimit)"
        self.labelHasError = self.folder.label.count == self.labelLimit
        self.validationError = false
    }

    func onChangeIcon(_ icon: String) {
        if self.folder.icon.count > self.iconLimit {
            self.folder.icon = String(icon.suffix(iconLimit))
        }
    }

    func onShowPrimaryColorPicker() {
        self.showPrimaryColorPicker = true
    }

    func onClosePrimaryColorPicker() {
        self.showPrimaryColorPicker = false
    }

    func onShowSecondaryColorPicker() {
        self.showSecondaryColorPicker = true
    }

    func onCloseSecondaryColorPicker() {
        self.showSecondaryColorPicker = false
    }

    func validate() -> Bool {
        if self.folder.label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.validationError = true
            self.labelHasError = true
            self.labelCounterText = "Can not be empty"
            return false
        }
        return true
    }
}
