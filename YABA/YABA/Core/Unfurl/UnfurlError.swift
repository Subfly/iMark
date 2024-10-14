//
//  UnfurlError.swift
//  YABA
//
//  Created by Ali Taha on 13.10.2024.
//

enum UnfurlError: Error {
    case cannotCreateURL(String)
    case unableToUnfurl(String)
    case urlNotValid(String)
    case clientError(String)
    case serverError(String)
}
