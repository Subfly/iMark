//
//  DottedFolderView.swift
//  YABA
//
//  Created by Ali Taha on 10.10.2024.
//

import SwiftUI

struct DottedFolderView: View {
    let label: String
    let onClicked: () -> Void

    var body: some View {
        Button {
            self.onClicked()
        } label: {
            ZStack {
                Color.clear
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "folder")
                        Spacer()
                        Image(systemName: "ellipsis")
                    }
                    Spacer()
                    Text(self.label)
                        .font(.title2)
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
    DottedFolderView(
        label: "",
        onClicked: {}
    )
}
