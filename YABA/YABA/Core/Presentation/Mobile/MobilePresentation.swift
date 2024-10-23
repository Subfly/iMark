//
//  MobilePresentation.swift
//  YABA
//
//  Created by Ali Taha on 23.10.2024.
//

import SwiftUI

struct MobilePresentation: View {
    @AppStorage("notPassedOnboarding")
    private var notPassedOnboarding: Bool = true

    @State
    var navigationManager: NavigationManager = .init()
    
    var body: some View {
        NavigationStack(path: self.$navigationManager.routes) {
            HomeScreen()
                .navigationDestination(
                    for: Destination.self,
                    destination: {
                        $0.getView()
                    }
                )
        }
        .sheet(isPresented: self.$navigationManager.createBookmarkSheetActive) {
            self.createBookmarkSheetContent
        }
        .sheet(isPresented: self.$navigationManager.createFolderSheetActive) {
            self.createFolderSheetContent
        }
        .sheet(isPresented: self.$navigationManager.createTagSheetActive) {
            self.createTagSheetContent
        }
        .popover(isPresented: self.$notPassedOnboarding) {
            self.onboardingPopoverContent
        }
        .environment(self.navigationManager)
    }
    
    @ViewBuilder
    private var createBookmarkSheetContent: some View {
        CreateBookmarkSheetContent(
            bookmark: self.navigationManager.selectedBookmark,
            onDismiss: {
                self.navigationManager.onDismissBookmarkCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var createFolderSheetContent: some View {
        CreateFolderSheetContent(
            folder: self.navigationManager.selectedFolder,
            onDismiss: {
                self.navigationManager.onDismissFolderCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var createTagSheetContent: some View {
        CreateTagSheetContent(
            tag: self.navigationManager.selectedTag,
            onDismiss: {
                self.navigationManager.onDismissTagCreationSheet()
            }
        )
    }
    
    @ViewBuilder
    private var onboardingPopoverContent: some View {
        OnboardingView(
            onEndOnboarding: {
                self.notPassedOnboarding = false
            }
        )
    }
}

#Preview {
    MobilePresentation()
}
