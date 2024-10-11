//
//  ShareSheet.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//  Copied from https://stackoverflow.com/questions/69892283/create-a-share-sheet-in-ios-15-with-swiftui
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let bookmarkLink: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems: [Any] = [self.bookmarkLink]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.modalPresentationStyle = .formSheet
        let detents: [UISheetPresentationController.Detent] = [.medium()]
        activityViewController.sheetPresentationController?.detents = detents
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    if let url = URL(string: "") {
        ShareSheet(bookmarkLink: url)
    }
}
