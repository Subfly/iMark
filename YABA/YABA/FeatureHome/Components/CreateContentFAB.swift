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
            Rectangle()
                .fill()
                .foregroundStyle(Material.ultraThin)
                .blur(radius: 8)
                .opacity(self.isActive ? 0.6 : 0)
                .onTapGesture {
                    self.onDismissRequest()
                }
        }.overlay(alignment: .bottom) {
            VStack(spacing: 15) {
                self.clickableMiniFab(type: .bookmark)
                self.clickableMiniFab(type: .folder)
                self.clickableMiniFab(type: .tag)
                Button {
                    self.onClickAction(.main)
                } label: {
                    self.fab(isMini: false, type: .main)
                }
            }
            .padding(.bottom)
            .padding(.bottom)
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
        }
        .shadow(radius: 4)
        .rotationEffect(Angle(degrees: isMini ? 0 : self.isActive ? 45 : 0))
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
            self.onClickAction(type)
            self.onDismissRequest()
        } label: {
            self.fab(isMini: true, type: type)
                .shadow(radius: 2)
        }
        .scaleEffect(self.isActive ? 1 : 0)
        .opacity(self.isActive ? 1 : 0)
        .animation(.easeInOut.delay(duration), value: self.isActive)
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
