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

    var urlErrorText: String
    var urlHasError: Bool = false
    var urlHasWarning: Bool = false
    
    var shouldShowFolderSelectionPopover: Bool = false
    var shouldShowCreateFolderSheet: Bool = false
    
    var shouldShowTagSelectionPopover: Bool = false
    var shouldShowCreateTagSheet: Bool = false
    
    var unfurling: Bool = false
    
    var creationFolder: Folder?
    var creationTag: Tag?
    
    var bookmark: Bookmark

    init(bookmark: Bookmark?) {
        self.urlErrorText = ""
        self.bookmark = bookmark ?? .empty()
        self.isEditMode = bookmark != nil
    }

    func onChangeLink(_ text: String) async {
        self.unfurling = true
        self.bookmark.link = text

        if text.isEmpty {
            self.clearWarningsAndErrors()
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

            self.clearWarningsAndErrors()
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
    
    func onSelectFolder(folder: Folder) {
        self.bookmark.folder = folder
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
    
    private func fillAsWarning(with errorMessage: String) {
        self.urlErrorText = errorMessage
        self.urlHasError = false
        self.urlHasWarning = true
    }
    
    private func fillAsError(with errorMessage: String) {
        self.urlErrorText = errorMessage
        self.urlHasError = true
        self.urlHasWarning = false
    }
    
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
    }
    
    private func clearWarningsAndErrors() {
        self.urlErrorText = ""
        self.urlHasError = false
        self.urlHasWarning = false
    }
}
