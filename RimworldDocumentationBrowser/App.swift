//
//  RimworldDocumentationBrowserApp.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-06.
//

import SwiftUI
import RimworldDocumentationKit

@main struct RimworldDocumentationBrowserApp: App {
    var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(RimworldArchive.latest)
		}
		DocumentGroup(viewing: RimworldArchiveDocument.self) { document in
			ContentView()
				.environment(document.document.archive)
		}
    }
}
