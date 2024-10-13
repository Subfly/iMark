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
    let labelLimit = 15
    let iconLimit = 1

    var labelCounterText: String
    var labelHasError: Bool = false

    var showPrimaryColorPicker: Bool = false
    var showSecondaryColorPicker: Bool = false

    var tag: Tag

    init(tag: Tag?) {
        self.labelCounterText = "0\\\(labelLimit)"
        self.tag = tag ?? .empty()
        self.isEditMode = tag != nil
    }

    func onChaneLabel(_ text: String) {
        if self.tag.label.count > self.labelLimit {
            self.tag.label = String(text.prefix(self.labelLimit))
        }
        self.labelCounterText = "\(self.tag.label.count)\\\(self.labelLimit)"
        self.labelHasError = self.tag.label.count == self.labelLimit
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
}
