//
//  HomeScreen.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(NavigationManager.self)
    private var navigationManager

    @Bindable
    var homeVM: HomeVM = .init()

    var body: some View {
        ZStack {
            LazyVGrid(columns: [
                GridItem(),
                GridItem()
            ]) {}
            VStack {
                Spacer()
                CreateContentFAB(isActive: self.homeVM.shouldShowMiniButtons) { type in
                    switch type {
                    case .bookmark:
                        navigationManager.showBookmarkCreationSheet()
                    case .folder:
                        navigationManager.showFolderCreationSheet()
                    case .tag:
                        navigationManager.showTagCreationSheet()
                    case .main:
                        withAnimation {
                            self.homeVM.toggleCreateMenu()
                        }
                    }
                }.padding(.bottom)
            }
        }
        .navigationTitle("Home")
        .searchable(
            text: self.$homeVM.searchQuery,
            prompt: "Search in Bookmarks..."
        )
    }
}
