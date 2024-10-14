//
//  CreateBookmarkVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class CreateBookmarkVM {
    private let unfurler: Unfurler = .init()
    
    let isEditMode: Bool
    let labelLimit = 25
    let descriptionLimit = 120

    // Error Text Related
    var urlErrorText: String
    var labelErrorText: String
    var folderErrorText: String
    
    // UI Error Presentation Related
    var urlHasError: Bool = false
    var urlHasWarning: Bool = false
    var labelHasValidationError: Bool = false
    var folderHasValidationError: Bool = false
    var validationError: Bool = false
    
    // Popover related
    var shouldShowFolderSelectionPopover: Bool = false
    var shouldShowCreateFolderSheet: Bool = false
    
    var shouldShowTagSelectionPopover: Bool = false
    var shouldShowCreateTagSheet: Bool = false
    
    // State variable for loading
    var unfurling: Bool = false
    
    // Items to hold during editing
    var creationFolder: Folder?
    var creationTag: Tag?
    
    // Main bookmark variable
    var bookmark: Bookmark

    init(
        bookmark: Bookmark?,
        isOpeningFromShareSheet: Bool
    ) {
        self.urlErrorText = ""
        self.labelErrorText = ""
        self.folderErrorText = ""
        self.bookmark = bookmark ?? .empty()
        self.isEditMode = bookmark != nil && !isOpeningFromShareSheet
    
        if isOpeningFromShareSheet {
            if let link = bookmark?.link {
                Task {
                    await self.onChangeLink(link)
                }
            }
        }
    }

    func onChangeLink(_ text: String) async {
        // Set state to loading
        self.unfurling = true
        self.bookmark.link = text

        // Link should be available, show error if not
        if text.isEmpty {
            self.urlErrorText = "Can not be empty"
            self.urlHasError = true
            self.urlHasWarning = false
            self.unfurling = false
            return
        }

        do {
            let linkPreview = try await self.unfurler.unfurl(urlString: text)

            guard let prefillContent = linkPreview else {
                self.fillAsWarning(with: "Content of the link can not be fetched")
                self.unfurling = false
                return
            }

            self.fillSuccess(with: prefillContent)
        } catch UnfurlError.urlNotValid(let errorMessage) {
            self.fillAsError(with: errorMessage)
        } catch UnfurlError.cannotCreateURL(let errorMessage) {
            self.fillAsError(with: errorMessage)
        } catch UnfurlError.unableToUnfurl(let errorMessage) {
            self.fillAsWarning(with: errorMessage)
        } catch UnfurlError.clientError(let errorMessage) {
            self.fillAsWarning(with: errorMessage)
        } catch UnfurlError.serverError(let errorMessage) {
            self.fillAsWarning(with: errorMessage)
        } catch {
            self.fillAsWarning(with: "Something went wrong, please try again later.")
        }
        self.unfurling = false
    }
    
    func onChangeLabel(_ text: String) {
        self.bookmark.label = text
        if text.isEmpty {
            self.labelErrorText = "Can not be empty"
            self.labelHasValidationError = true
        } else {
            self.labelErrorText = ""
            self.labelHasValidationError = false
        }
    }
    
    func onSelectFolder(folder: Folder) {
        self.bookmark.folder = folder
        self.folderErrorText = ""
        self.folderHasValidationError = false
    }
    
    func onSelectTag(tag: Tag) {
        if self.bookmark.tags.contains(tag) {
            self.bookmark.tags.removeAll(where: { $0 == tag })
        } else {
            self.bookmark.tags.append(tag)
        }
    }
    
    func onShowFolderSelectionPopover() {
        self.shouldShowFolderSelectionPopover = true
    }
    
    func onCloseFolderSelectionPopover() {
        self.shouldShowFolderSelectionPopover = false
    }
    
    func onShowFolderCreationSheet(folder: Folder?) {
        self.creationFolder = folder
        self.shouldShowCreateFolderSheet = true
    }
    
    func onCloseFolderCreationSheet() {
        self.creationFolder = nil
        self.shouldShowCreateFolderSheet = false
    }
    
    func onShowTagSelectionPopover() {
        self.shouldShowTagSelectionPopover = true
    }
    
    func onCloseTagSelectionPopover() {
        self.shouldShowTagSelectionPopover = false
    }
    
    func onShowTagCreationSheet(tag: Tag?) {
        self.creationTag = tag
        self.shouldShowCreateTagSheet = true
    }
    
    func onCloseTagCreationSheet() {
        self.creationTag = nil
        self.shouldShowCreateTagSheet = false
    }
    
    func validate() -> Bool {
        // Start with a valid state
        // and check if any of the rules are broken
        var isValid: Bool = true
        
        let linkEmpty = self.bookmark.link
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let linkCorrect = !linkEmpty && !self.urlHasWarning && !self.urlHasError

        let labelEmpty = self.bookmark.label
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        let folderNotSelected = self.bookmark.folder == nil

        // Link Rule: Link should not be empty
        if !linkCorrect {
            self.urlErrorText = "Can not be empty or invalid"
            self.urlHasError = true
            self.validationError = true
            isValid = false
        }

        // Label Rule: Label should be provided
        if labelEmpty {
            self.labelErrorText = "Can not be empty"
            self.labelHasValidationError = true
            self.validationError = true
            isValid = false
        }

        // Folder Rule: A folder should be selected
        if folderNotSelected {
            self.folderErrorText = "A folder should be selected"
            self.folderHasValidationError = true
            self.validationError = true
            isValid = false
        }

        return isValid
    }
    
    
    /**
     Helper to fill the warnings and set UI to warning state
     */
    private func fillAsWarning(with errorMessage: String) {
        self.urlErrorText = errorMessage
        self.urlHasError = false
        self.urlHasWarning = true
    }
    
    /**
     Helper to fill erors and set UI to error state
     */
    private func fillAsError(with errorMessage: String) {
        self.urlErrorText = errorMessage
        self.urlHasError = true
        self.urlHasWarning = false
    }
    
    /**
     Helper to fill bookmark with fetched values and clear UI errors and warnings
     */
    private func fillSuccess(with preview: LinkPreview) {
        if self.bookmark.label.isEmpty {
            self.bookmark.label = preview.title
        }
        
        if self.bookmark.bookmarkDescription.isEmpty {
            self.bookmark.bookmarkDescription = preview.description
        }
        
        if self.bookmark.imageUrl.isEmpty {
            self.bookmark.imageUrl = preview.imageUrl
        }
        
        if self.bookmark.domain.isEmpty {
            self.bookmark.domain = preview.siteName
        }
        
        self.urlErrorText = ""
        self.urlHasError = false
        self.urlHasWarning = false
    }
}
