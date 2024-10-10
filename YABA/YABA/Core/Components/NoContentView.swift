//
//  NoContentView.swift
//  YABA
//
//  Created by Ali Taha on 9.10.2024.
//

import SwiftUI

struct NoContentView: View {
    let iconName: String
    let message: String

    var body: some View {
        VStack {
            Image(systemName: self.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.secondary)
                .frame(width: 50, height: 50)
            Text(self.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }
}

#Preview {
    NoContentView(
        iconName: "tag",
        message: "No tags yet. Press + button to create your first folder."
    )
}
