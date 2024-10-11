//
//  CreationSheetContentView.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct CreationSheetContentView<Content: View>: View {
    let buttonLabel: String
    let onCreateContent: () -> Void
    let onDismissRequest: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            self.content()
        }
        .frame(maxWidth: .infinity)
        .presentationDragIndicator(.visible)
        .overlay(alignment: .bottom) {
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
        }
        .onDisappear {
            self.onDismissRequest()
        }
    }
}

#Preview {
    CreationSheetContentView(
        buttonLabel: "Label") {
            // Do Nothing
        } onDismissRequest: {
            // Do Nothing
        } content: {
            EmptyView()
    }
}
