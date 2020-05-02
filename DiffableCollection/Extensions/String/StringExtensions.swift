//
//  StringExtensions.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 30/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation

extension String {
    public func nonHtmlText() -> String {
        let nonHtmlString = replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return nonHtmlString
    }
    public func treatUrl() -> String {
        return nonHtmlText().replacingOccurrences(of: "\n", with: "")
    }
}
