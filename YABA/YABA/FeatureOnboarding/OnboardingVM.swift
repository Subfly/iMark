//
//  OnboardingVM.swift
//  YABA
//
//  Created by Ali Taha on 14.10.2024.
//

import Foundation
import SwiftUI
import OSLog

@Observable
class OnboardingVM {
    private var logger: Logger = .init()
    var currentPage: OnboardingPageType = .greeting
    
    var shouldShowTitle: Bool = false
    var shouldShowButton: Bool = false
    
    var createFoldersAndTags: Bool = true
    var isCreatingItems: Bool = false
    var itemsCreationDone: Bool = false
    
    func onNextStep() {
        self.currentPage = .finish
    }
    
    func onShowTitle() {
        self.shouldShowTitle = true
    }
    
    func onShowButton() {
        self.shouldShowButton = true
    }
    
    func preloadItems(
        onPreloadItems: @escaping ([Folder], [Tag]) -> Void
    ) {
        self.isCreatingItems = true
        
        if let url = Bundle.main.url(forResource: "preload_data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(PreloadDataHolder.self, from: data)
                let folders = jsonData.getFolderModels()
                let tags = jsonData.getTagModels()
                onPreloadItems(folders, tags)
            } catch {
                self.logger.log(
                    level: .error,
                    "[PRELOADER] Preload failed."
                )
                self.isCreatingItems = false
                return
            }
        } else {
            self.logger.log(
                level: .error,
                "[PRELOADER] Cannot be able to open preload data file."
            )
            self.isCreatingItems = false
            return
        }
        
        self.isCreatingItems = false
        self.itemsCreationDone = true
    }
}
