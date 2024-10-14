//
//  OnboardingView.swift
//  YABA
//
//  Created by Ali Taha on 14.10.2024.
//

import SwiftUI

struct OnboardingView: View {
    let onEndOnboarding: () -> Void
    
    @State
    private var currentPage: OnboardingPageType = .greeting
    
    var body: some View {
        Text("Welcome to YABA")
    }
}

#Preview {
    OnboardingView(
        onEndOnboarding: {}
    )
}
