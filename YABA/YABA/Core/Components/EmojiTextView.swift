//
//  EmojiTextView.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//  Taken from: https://stackoverflow.com/questions/66397828/emoji-keyboard-swiftui
//

import SwiftUI

class UIEmojiTextField: UITextField {
    func setEmoji() {
        _ = self.textInputMode
    }

    override var textInputContextIdentifier: String? {
           return ""
    }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes where mode.primaryLanguage == "emoji" {
            self.keyboardType = .default // do not remove this
            return mode
        }
        return nil
    }
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""

    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        return emojiTextField
    }

    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(parent: EmojiTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
    }
}
