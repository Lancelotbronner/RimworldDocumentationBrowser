//
//  RimworldDocumentationBrowserApp.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-06.
//

import SwiftUI

@main struct RimworldDocumentationBrowserApp: App {
    var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.archive, .latest)
		}
		DocumentGroup(viewing: RimworldDocumentationArchiveDocument.self) { document in
			ContentView()
				.environment(\.archive, document.document.archive)
		}
    }
}
