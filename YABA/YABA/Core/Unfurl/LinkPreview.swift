//
//  LinkPreview.swift
//  YABA
//
//  Created by Ali Taha on 12.10.2024.
//

import Foundation

struct LinkPreview: Codable {
    let imageUrl: String
    let title: String
    let description: String
    let url: String
    let siteName: String
    let domain: String
    let creator: String
    let label1: String
    let label2: String
    let data1: String
    let data2: String
    
    func getPrettyPrintString() -> String {
        return """
            Image Url: \(self.imageUrl)
            Title: \(self.title)
            Description: \(self.description)
            Url: \(self.url)
            Site Name: \(self.siteName)
            Domain: \(self.domain)
            Creator: \(self.creator)
            Label 1: \(self.label1)
            Label 2: \(self.label2)
            Data 1: \(self.data1)
            Data 2: \(self.data2)
        """
    }
}
