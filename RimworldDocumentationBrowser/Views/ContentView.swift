//
//  ContentView.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-06.
//

import SwiftUI
import RimworldDocumentationKit

struct ContentView: View {
	@Environment(RimworldArchive.self) private var archive

	private let navigation = Navigation()

	init() {
#if os(iOS)
		UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
#endif
	}

    var body: some View {
		let _navigation = Bindable(navigation)
		NavigationSplitView {
			List(selection: _navigation.route) {
				Section("Metadata") {
					NavigationLink(value: Route.modules) {
						Label("Modules", systemImage: "cube")
							.badge(archive.modules.count)
					}
					NavigationLink(value: Route.issues) {
						Label("Issues", systemImage: "cube")
							.badge(archive.modules.count)
					}
				}
				Section("Schema") {
					NavigationLink(value: Route.tags) {
						Label("Tags", systemImage: "tag")
							.badge(archive.tags.count)
					}
					NavigationLink(value: Route.classes) {
						Label("Classes", systemImage: "brain")
							.badge(archive.classes.count)
					}
					NavigationLink(value: Route.attributes) {
						Label("Attributes", systemImage: "tag")
							.badge(archive.attributes.count)
					}
				}
				Section("Content") {
					NavigationLink(value: Route.definitions) {
						Label("Definitions", systemImage: "cube")
							.badge(archive.definitions.count)
					}
					NavigationLink(value: Route.resources) {
						Label("Resources", systemImage: "resources")
							.badge(archive.resources.count)
					}
				}
			}
			.badgeProminence(.decreased)
		} detail: {
			NavigationStack(path: _navigation.path) {
				if let route = navigation.route {
					Router(to: route)
						.navigationDestination(for: Class.self, destination: ClassView.init)
						.navigationDestination(for: Module.self, destination: ModuleView.init)
						.navigationDestination(for: Tag.self, destination: TagView.init)
				} else {
					ContentUnavailableView("Select something from the sidebar", systemImage: "questionmark", description: Text("View the different elements the documentation archive has to offer!"))
				}
			}
		}
    }
}

#Preview {
    ContentView()
		.environment(RimworldArchive.latest)
}
