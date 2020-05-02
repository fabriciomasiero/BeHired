//
//  JobsError.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation

enum JobsError: Error {
    case parsing(description: String)
    case network(description: String)
    case intern(description: String)
}
