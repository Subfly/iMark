//
//  CreateContentFAB.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct CreateContentFAB: View {
    let isActive: Bool
    let onClickAction: (_ type: CreationType) -> Void
    let onDismissRequest: () -> Void

    var body: some View {
        ZStack {
            if isActive {
                Rectangle()
                    .fill()
                    .foregroundStyle(.secondary.opacity(0.5))
                    .blur(radius: 24)
                    .onTapGesture {
                        onDismissRequest()
                    }
            }
        }.overlay(alignment: .bottom) {
            VStack(spacing: 15) {
                clickableMiniFab(type: .bookmark)
                clickableMiniFab(type: .folder)
                clickableMiniFab(type: .tag)
                Button {
                    onClickAction(.main)
                } label: {
                    fab(isMini: false, type: .main)
                }
            }
        }
    }

    @ViewBuilder
    private func fab(isMini: Bool, type: CreationType) -> some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(
                    width: isMini ? 48 : 72,
                    height: isMini ? 48 : 72
                )
            Image(systemName: type.getIcon())
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .font(.system(size: isMini ? 18 : 24))
        }.rotationEffect(Angle(degrees: isMini ? 0 : self.isActive ? 45 : 0))
    }

    @ViewBuilder
    private func clickableMiniFab(type: CreationType) -> some View {
        let duration = switch type {
        case .bookmark:
            isActive ? 0.3 : 0.1
        case .folder:
            0.2
        case .tag:
            isActive ? 0.1 : 0.3
        default:
            0.0
        }

        Button {
            onClickAction(type)
        } label: {
            fab(isMini: true, type: type)
        }
        .scaleEffect(isActive ? 1 : 0)
        .opacity(isActive ? 1 : 0)
        .animation(.easeInOut.delay(duration), value: isActive)
        .transition(.slide)
    }
}

#Preview {
    CreateContentFAB(isActive: true) { _ in
        // Do Nothing
    } onDismissRequest: {
        // Do Nothing
    }
}
