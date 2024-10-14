//
//  BookmarkDetailVM.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

import SwiftUI

@Observable
class BookmarkDetailVM: ObservableObject {
    private let unfurler: Unfurler = .init()
    var bookmark: Bookmark
    
    var showBookmarkCreationSheet: Bool = false
    var showShareSheet: Bool = false
    var showBookmarkDeleteDialog: Bool = false
    
    var deletingBookmarkLabel: String = ""

    var unfurling: Bool = false

    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }
    
    func onShowBookmarkCreationSheet() {
        self.showBookmarkCreationSheet = true
    }
    
    func onCloseBookmarkCreationSheet() {
        self.showBookmarkCreationSheet = false
    }
    
    func onShowShareSheet() {
        self.showShareSheet = true
    }
    
    func onCloseShareSheet() {
        self.showShareSheet = false
    }
    
    func onShowBookmarkDeleteDialog() {
        self.deletingBookmarkLabel = "Are you sure you want to delete \(self.bookmark.label), this can not be undone!"
        self.showBookmarkDeleteDialog = true
    }
    
    func onCloseBookmarkDeleteDialog() {
        self.deletingBookmarkLabel = ""
        self.showBookmarkDeleteDialog = false
    }

    func onClickOpenLink() {
        if let url = URL(string: self.bookmark.link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func onRefreshBookmark() async {
        self.unfurling = true
        
        do {
            let linkPreview = try await self.unfurler.unfurl(
                urlString: self.bookmark.link
            )

            guard let prefillContent = linkPreview else {
                self.unfurling = false
                return
            }

            self.fillSuccess(with: prefillContent)
        } catch UnfurlError.urlNotValid(let errorMessage) {
            // TASK: Show global error component
        } catch UnfurlError.cannotCreateURL(let errorMessage) {
            // TASK: Show global error component
        } catch UnfurlError.unableToUnfurl(let errorMessage) {
            // TASK: Show global error component
        } catch UnfurlError.clientError(let errorMessage) {
            // TASK: Show global error component
        } catch UnfurlError.serverError(let errorMessage) {
            // TASK: Show global error component
        } catch {
            // TASK: Show global error component
        }
        self.unfurling = false
    }

    private func fillSuccess(with preview: LinkPreview) {
        if self.bookmark.bookmarkDescription.isEmpty {
            self.bookmark.bookmarkDescription = preview.description
        }

        self.bookmark.imageUrl = preview.imageUrl
        self.bookmark.domain = preview.siteName
    }
}
