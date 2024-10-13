//
//  CreateTagVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

@Observable
class CreateTagVM {
    let isEditMode: Bool
    let labelLimit = 20
    let iconLimit = 1

    var labelCounterText: String
    var labelHasError: Bool = false

    var showPrimaryColorPicker: Bool = false
    var showSecondaryColorPicker: Bool = false
    
    var validationError: Bool = false

    var tag: Tag

    init(tag: Tag?) {
        let labelSize = tag?.label.count ?? 0
        self.labelCounterText = "\(labelSize)\\\(labelLimit)"
        self.tag = tag ?? .empty()
        self.isEditMode = tag != nil
    }

    func onChaneLabel(_ text: String) {
        if self.tag.label.count > self.labelLimit {
            self.tag.label = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.tag.label.count)\\\(self.labelLimit)"
        self.labelHasError = self.tag.label.count == self.labelLimit
        self.validationError = false
    }

    func onChangeIcon(_ icon: String) {
        if self.tag.icon.count > self.iconLimit {
            self.tag.icon = String(icon.suffix(iconLimit))
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
        if self.tag.label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.validationError = true
            self.labelHasError = true
            self.labelCounterText = "Can not be empty"
            return false
        }
        return true
    }
}
