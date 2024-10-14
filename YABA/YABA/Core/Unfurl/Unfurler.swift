//
//  Unfurler.swift
//  YABA
//
//  Created by Ali Taha on 12.10.2024.
//

import Foundation
import OSLog

class Unfurler {
    private let logger = Logger()

    func unfurl(urlString: String) async throws -> LinkPreview? {
        // Try to create the URL
        guard let url = URL(string: urlString) else {
            self.logger.log(level: .error, "[UNFURLER] Cannot create url for: \(urlString)")
            throw UnfurlError.cannotCreateURL("Can not create the URL from the link")
        }

        // Set agent to googlebot to force websites preload headers
        var request = URLRequest(url: url)
        request.setValue("googlebot", forHTTPHeaderField: "user-agent")

        do {
            let (data, result) = try await URLSession.shared.data(for: request)
            let responseCode = (result as? HTTPURLResponse)?.statusCode ?? -1
            
            self.logger.log(level: .info, "[UNFURLER] HTTP Response Code: \(responseCode)")
            
            // Check status code for UI errors
            if responseCode >= 400 {
                throw UnfurlError.clientError(
                    "Can not autofill the content. Either too many request or server blocked the request."
                )
            } else if responseCode >= 500 {
                throw UnfurlError.serverError("Can not autofill the content. Probably server is down.")
            }

            if let htmlString = String(data: data, encoding: .utf8) {
                let model = self.extractMetadata(from: htmlString)
                guard let modelToReturn = model else {
                    self.logger.log(
                        level: .error,
                        "[UNFURLER] Cannot Unfurl the model for: \(urlString)"
                    )
                    throw UnfurlError.unableToUnfurl("Autofill is not available for this link")
                }
                self.logger.log(
                    level: .info,
                    "[UNFURLER] Unfurled model: \n\(modelToReturn.getPrettyPrintString())"
                )
                return modelToReturn
            } else {
                return nil
            }
        } catch {
            self.logger.log(
                level: .error,
                "[UNFURLER] URL Error: \n\(error.localizedDescription)"
            )
            if error is UnfurlError {
                throw error
            } else {
                throw UnfurlError.urlNotValid("Not a vlid link")
            }
        }
    }

    private func extractMetadata(from html: String) -> LinkPreview? {
        let metaTags = self.findMetaTags(in: html)
        let metaData = self.parseMetadata(from: metaTags)

        let imageUrl = metaData["twitter:image"] ?? metaData["og:image"] ?? ""
        let title = metaData["twitter:title"] ?? metaData["og:title"] ?? ""
        let description = metaData["twitter:description"] ?? metaData["og:description"] ?? ""
        let url = metaData["twitter:url"] ?? metaData["og:url"] ?? ""
        let siteName = metaData["twitter:site"] ?? metaData["og:site_name"] ?? ""
        // Give priority to og tag because I don't need @username as a site name :D
        // TASK: CHANGE PRIORITY ACCORDING TO WEBSITE (IF TWITTER) IN THE FUTURE
        let domain = metaData["og:domain"] ?? metaData["twitter:domain"] ?? ""
        let creator = metaData["twitter:creator"] ?? ""
        let label1 = metaData["twitter:label1"] ?? ""
        let label2 = metaData["twitter:label2"] ?? ""
        let data1 = metaData["twitter:data1"] ?? ""
        let data2 = metaData["twitter:data2"] ?? ""

        return LinkPreview(
            imageUrl: imageUrl.trimmingCharacters(in: .whitespacesAndNewlines),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            url: url.trimmingCharacters(in: .whitespacesAndNewlines),
            siteName: siteName.trimmingCharacters(in: .whitespacesAndNewlines),
            domain: domain.trimmingCharacters(in: .whitespacesAndNewlines),
            creator: creator.trimmingCharacters(in: .whitespacesAndNewlines),
            label1: label1.trimmingCharacters(in: .whitespacesAndNewlines),
            label2: label2.trimmingCharacters(in: .whitespacesAndNewlines),
            data1: data1.trimmingCharacters(in: .whitespacesAndNewlines),
            data2: data2.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    /**
        Get all meta tags in the header of a given html
     */
    private func findMetaTags(in html: String) -> [String] {
        let pattern = "<meta[^>]+>"
        var metaTags: [String] = []
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let nsString = html as NSString
            let results = regex.matches(
                in: html,
                options: [],
                range: NSRange(location: 0, length: nsString.length)
            )
            
            for match in results {
                let metaTag = nsString.substring(with: match.range)
                metaTags.append(metaTag)
            }
        } catch {
            self.logger.log(
                level: .error,
                "[UNFURLER] Cannot create regular expression: \(error.localizedDescription)"
            )
        }
        return metaTags
    }
    
    private func parseMetadata(from metaTags: [String]) -> [String:String] {
        var metadata: [String: String] = [:]
            
        for tag in metaTags {
            let nsTag = tag as NSString

            let propertyKey = nsTag.range(of: "property=")
            let nameKey = nsTag.range(of: "name=")
            let contentKey = nsTag.range(of: "content=")

            var key: String?
            
            // Parse string with the given values
            if propertyKey.location != NSNotFound {
                key = self.extractValue(from: nsTag, at: propertyKey)
            } else if nameKey.location != NSNotFound {
                key = self.extractValue(from: nsTag, at: nameKey)
            }

            var value: String?
            if contentKey.location != NSNotFound {
                value = self.extractValue(from: nsTag, at: contentKey)
            }

            if let key = key, let value = value {
                metadata[key] = value
            }
        }

        return metadata
    }

    /**
        Find the given tag inside a meta tag and parse the value
     */
    private func extractValue(from tag: NSString, at range: NSRange) -> String? {
        let start = range.location + range.length
        let quoteRange = tag.range(
            of: "\"",
            options: [],
            range: NSRange(location: start, length: tag.length - start)
        )

        guard quoteRange.location != NSNotFound else {
            return nil
        }

        let closingQuoteRange = tag.range(
            of: "\"",
            options: [],
            range: NSRange(
                location: quoteRange.location + 1,
                length: tag.length - quoteRange.location - 1
            )
        )

        guard closingQuoteRange.location != NSNotFound else {
            return nil
        }

        return tag.substring(
            with: NSRange(
                location: quoteRange.location + 1,
                length: closingQuoteRange.location - quoteRange.location - 1
            )
        )
    }
}
