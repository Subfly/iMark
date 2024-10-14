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
    // Constants
    let labelLimit = 20
    let iconLimit = 1

    // UI Error variables
    var labelCounterText: String
    var labelHasError: Bool = false

    // Picker state variables
    var showPrimaryColorPicker: Bool = false
    var showSecondaryColorPicker: Bool = false
    
    // Validation state
    var validationError: Bool = false

    // Main state variables
    var tag: Tag
    let isEditMode: Bool

    /**
     For editing, tag should be set as nil
     */
    init(tag: Tag?) {
        let labelSize = tag?.label.count ?? 0
        self.labelCounterText = "\(labelSize)\\\(labelLimit)"
        self.tag = tag ?? .empty()
        self.isEditMode = tag != nil
    }

    func onChaneLabel(_ text: String) {
        // Input should not exceed the limit
        // Parse the prefix with limit
        if self.tag.label.count > self.labelLimit {
            self.tag.label = String(text.prefix(self.labelLimit))
        }
        
        // Show remaining input size and set error if limit reached
        self.labelCounterText = "\(self.tag.label.count)\\\(self.labelLimit)"
        self.labelHasError = self.tag.label.count == self.labelLimit
        self.validationError = false
    }

    func onChangeIcon(_ icon: String) {
        // Icon should not be more than 1 character
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
        // Label should not be empty, this is the only rule
        if self.tag.label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.validationError = true
            self.labelHasError = true
            self.labelCounterText = "Can not be empty"
            return false
        }
        return true
    }
}
