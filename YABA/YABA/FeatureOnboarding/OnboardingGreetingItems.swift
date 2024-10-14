//
// OnboardingGreetingItems.swift
// YABA
//
// Created by Ali Taha on 14.10.2024.
//

import SwiftUI

struct OnboardingGreetingItems {
    private init() {}
    static func getItems() -> [OnboardingGreetingItem] {
        return [
            OnboardingGreetingItem(
                iconName: "bookmark",
                label: """
Easily manage your bookmarks. Create folders and tags. No more hassle of searching your favorite content!
""",
                iconBackgroundColorPrimary: .teal,
                iconBackgroundColorSecondary: .green,
                appearingOrder: 1
            ),
            OnboardingGreetingItem(
                iconName: "square.and.arrow.up",
                label: "Share any link from any app, and YABA will take care the rest for you.",
                iconBackgroundColorPrimary: .indigo,
                iconBackgroundColorSecondary: .purple,
                appearingOrder: 2
            ),
            OnboardingGreetingItem(
                iconName: "lock.icloud",
                label: "Everything is inside your device. No analytics. No data sharing. No tracking.",
                iconBackgroundColorPrimary: .orange,
                iconBackgroundColorSecondary: .yellow,
                appearingOrder: 3
            ),
            // TASK: ADD ICLOUD LIMITS FOR THAT SENTENCE
            OnboardingGreetingItem(
                iconName: "gift",
                label: "YABA was, is and will always be free. No ads. No subscriptions. No limits.",
                iconBackgroundColorPrimary: .blue,
                iconBackgroundColorSecondary: .mint,
                appearingOrder: 4
            ),
        ]
    }
}

struct OnboardingGreetingItem: Identifiable {
    let id = UUID()
    let iconName: String
    let label: String
    let iconBackgroundColorPrimary: Color
    let iconBackgroundColorSecondary: Color
    let appearingOrder: Int
    static func empty() -> OnboardingGreetingItem {
        return OnboardingGreetingItem(
            iconName: "",
            label: "",
            iconBackgroundColorPrimary: .accentColor,
            iconBackgroundColorSecondary: .accentColor,
            appearingOrder: 0
        )
    }
}
