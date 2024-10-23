//
//  OnboardingView.swift
//  YABA
//
//  Created by Ali Taha on 14.10.2024.
//

import SwiftUI

struct OnboardingView: View {
    let onEndOnboarding: () -> Void
    
    @Environment(\.modelContext)
    private var modelContext

    @State
    private var onboardingVM: OnboardingVM = .init()

    var body: some View {
        VStack {
            self.titleView
            Spacer()
            TabView(selection: self.$onboardingVM.currentPage) {
                self.greetingPage.tag(OnboardingPageType.greeting)
                self.finishPage.tag(OnboardingPageType.finish)
            }
            .scrollDisabled(true)
            .tabViewStyle(.page(indexDisplayMode: .never))
            Spacer()
            self.button
        }.padding()
    }

    @ViewBuilder
    private var titleView: some View {
        VStack(spacing: 16) {
            if self.onboardingVM.currentPage == .greeting {
                Image("OnboardingAppIcon")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Image(systemName: "wand.and.sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60, alignment: .center)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .purple,
                                        .indigo,
                                        .purple
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    .padding(.bottom)
            }
            Text(
                self.onboardingVM.currentPage == .greeting
                ? "Welcome to YABA"
                : "One last thing..."
            )
            .font(.largeTitle)
            .fontWeight(.bold)
        }
        .padding(.top, 80)
        .opacity(self.onboardingVM.shouldShowTitle ? 1 : 0)
        .onAppear {
            withAnimation(.smooth.delay(0.75)) {
                self.onboardingVM.onShowTitle()
            }
        }
    }

    @ViewBuilder
    private var greetingPage: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(OnboardingGreetingItems.getItems()) { item in
                OnboardingGreetingItemView(item: item)
            }
        }
    }

    @ViewBuilder
    private var finishPage: some View {
        VStack {
            Spacer()
            Text("""
YABA can create some folders and tags for you, just to give you a headstart. Would you like to do it now?
"""
            )
            .font(.callout)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            Spacer()
            Toggle("Create for me", isOn: self.$onboardingVM.createFoldersAndTags)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                }
                .padding(.horizontal)
                .disabled(self.onboardingVM.isCreatingItems)
            Spacer()
        }
    }

    @ViewBuilder
    private var button: some View {
        Button {
            withAnimation {
                self.onButtonPressed()
            }
        } label: {
            HStack {
                if self.onboardingVM.isCreatingItems {
                    ProgressView()
                } else if self.onboardingVM.itemsCreationDone {
                    Image(systemName: "checkmark.circle")
                }
                Text(
                    self.onboardingVM.currentPage == .greeting
                    ? "Continue"
                    : self.onboardingVM.itemsCreationDone
                    ? "Start Using YABA"
                    : self.onboardingVM.isCreatingItems
                    ? "Creating..."
                    : self.onboardingVM.createFoldersAndTags
                    ? "Create"
                    : "Start Using YABA"
                )
            }
            .fontWeight(.medium)
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: 56, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        self.onboardingVM.itemsCreationDone ? .green : .accentColor
                    )
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .opacity(self.onboardingVM.shouldShowButton ? 1 : 0)
        .onAppear {
            withAnimation(.smooth.delay(3.5)) {
                self.onboardingVM.onShowButton()
            }
        }
        .disabled(self.onboardingVM.isCreatingItems)
    }

    private func onButtonPressed() {
        if self.onboardingVM.currentPage == .greeting {
            self.onboardingVM.onNextStep()
        } else {
            if self.onboardingVM.itemsCreationDone {
                // Called when preload is succesful
                self.onEndOnboarding()
            } else if self.onboardingVM.createFoldersAndTags {
                // Call preloading but don't navigate to anywhere
                self.onboardingVM.preloadItems { folders, tags in
                    // Inline callback that saves each
                    // folder and tag one by one
                    Task {
                        for folder in folders {
                            self.modelContext.insert(folder)
                            try? await Task.sleep(for: .milliseconds(1))
                        }
                        for tag in tags {
                            self.modelContext.insert(tag)
                            try? await Task.sleep(for: .milliseconds(1))
                        }
                        try? self.modelContext.save()
                    }
                }
            } else {
                // Called when user skips preloading
                self.onEndOnboarding()
            }
        }
    }
}

#Preview {
    OnboardingView(
        onEndOnboarding: {}
    )
}
