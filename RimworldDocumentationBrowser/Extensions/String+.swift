//
//  String+.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-08.
//

import Foundation

extension String {

	public mutating func titleCase() {
		replace(/_(\p{L})/) { match in
			" \(match.output.1.localizedUppercase)"
		}
		replace(/(\p{Ll})(\p{Lu})/) { match in
			"\(match.output.1) \(match.output.2)"
		}
		replace(/(\p{Lu}+?)(\p{Lu})/) { match in
			"\(match.output.1) \(match.output.2)"
		}
		self = localizedCapitalized
	}

	public var titleCased: String {
		var tmp = self
		tmp.titleCase()
		return tmp
	}

}
