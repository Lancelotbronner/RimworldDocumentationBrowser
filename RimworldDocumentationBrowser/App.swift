//
//  RimworldDocumentationBrowserApp.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-06.
//

import SwiftUI

@main struct RimworldDocumentationBrowserApp: App {
    var body: some Scene {
		DocumentGroup(newDocument: RimworldDocumentationArchiveDocument(.latest)) { document in
			ContentView()
				.environment(\.archive, document.document.archive)
		}
    }
}
