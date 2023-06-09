//
//  Environment+.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI

extension EnvironmentValues {

	public var archive: RimworldDocumentationArchive {
		_read { yield self[DocumentationArchiveKey.self] }
		_modify { yield &self[DocumentationArchiveKey.self] }
	}

	public var navigation: NavigationPath {
		_read { yield _navigation.wrappedValue }
		_modify { yield &_navigation.wrappedValue }
	}

	public var _navigation: Binding<NavigationPath> {
		_read { yield self[NavigationPathKey.self] }
		_modify { yield &self[NavigationPathKey.self] }
	}

}

private struct DocumentationArchiveKey: EnvironmentKey {
	static let defaultValue = RimworldDocumentationArchive("New Documentation Archive", version: "none")
}

private struct NavigationPathKey: EnvironmentKey {
	static var defaultValueStorage = NavigationPath()
	static let defaultValue = Binding { defaultValueStorage } set: { defaultValueStorage = $0 }
}
