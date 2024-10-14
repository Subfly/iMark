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
        // Show loading
        self.isCreatingItems = true
        
        // Try to open the preload data
        if let url = Bundle.main.url(forResource: "preload_data", withExtension: "json") {
            do {
                // Try to parse json
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(PreloadDataHolder.self, from: data)
                
                let folders = jsonData.getFolderModels()
                let tags = jsonData.getTagModels()
                
                // Callback function for SwiftData to save on UI
                // Well played SwiftData, well played...
                onPreloadItems(folders, tags)
            } catch {
                // In case of error, stop loading
                self.logger.log(
                    level: .error,
                    "[PRELOADER] Preload failed."
                )
                self.isCreatingItems = false
                return
            }
        } else {
            // In case of error, stop loading
            self.logger.log(
                level: .error,
                "[PRELOADER] Cannot be able to open preload data file."
            )
            self.isCreatingItems = false
            return
        }
        
        // Stop loading on succesful load
        self.isCreatingItems = false
        self.itemsCreationDone = true
    }
}
