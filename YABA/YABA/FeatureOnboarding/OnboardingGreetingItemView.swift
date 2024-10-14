//
//  OnboardingGreetingItemView.swift
//  YABA
//
//  Created by Ali Taha on 14.10.2024.
//

import SwiftUI

struct OnboardingGreetingItemView: View {
    let item: OnboardingGreetingItem
    
    @State
    private var showContent: Bool = false
    
    var body: some View {
        HStack(spacing: 32) {
            Image(systemName: self.item.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    self.item.iconBackgroundColorPrimary,
                                    self.item.iconBackgroundColorSecondary,
                                    self.item.iconBackgroundColorPrimary,
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60, alignment: .center)
                }
            Text(self.item.label)
                .font(.callout)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
        .opacity(self.showContent ? 1 : 0)
        .onAppear {
            let delay = 1 + (Double(self.item.appearingOrder) * 0.5)
            withAnimation(.smooth.delay(delay)) {
                self.showContent = true
            }
        }
    }
}

#Preview {
    OnboardingGreetingItemView(item: .empty())
}
