//
//  CreationSheetContentView.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct CreationSheetContentView<Content: View>: View {
    let buttonLabel: String
    let hasError: Bool
    let onCreateContent: () -> Void
    let onDismissRequest: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        self.content()
            .safeAreaInset(edge: .bottom) {
                Button {
                    self.onCreateContent()
                } label: {
                    Text(self.buttonLabel)
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 56, alignment: .center)
                        .background {
                            RoundedRectangle(
                                cornerSize: CGSize(width: 16, height: 16)
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .offset(x: self.hasError ? -8 : 0)
                .animation(
                    Animation.default.repeatCount(3, autoreverses: true).speed(6),
                    value: self.hasError
                )
            }
            .frame(maxWidth: .infinity)
            .presentationDragIndicator(.visible)
            .onDisappear {
                self.onDismissRequest()
            }
    }
}

#Preview {
    CreationSheetContentView(buttonLabel: "Label", hasError: false) {
            // Do Nothing
        } onDismissRequest: {
            // Do Nothing
        } content: {
            EmptyView()
    }
}
