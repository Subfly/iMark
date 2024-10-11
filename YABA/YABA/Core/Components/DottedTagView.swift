//
//  DottedTagView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct DottedTagView: View {
    let label: String
    let onClicked: () -> Void

    var body: some View {
        Button {
            self.onClicked()
        } label: {
            ZStack {
                Color.clear
                HStack {
                    Image(systemName: "tag")
                    Text(self.label)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                            .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#Preview {
    DottedTagView(
        label: "",
        onClicked: {}
    )
}
