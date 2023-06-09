//
//  ContentView.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-06.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.archive) private var archive
	@Environment(\._navigation) private var _navigation

	@State private var page: String?

	init() {
#if os(iOS)
		UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
#endif
	}

    var body: some View {
		NavigationSplitView {
			List(selection: $page) {
				NavigationLink(value: "metadata") {
					Label("Metadata", systemImage: "line.horizontal.3")
						.badge(archive.warnings.count + archive.errors.count)
						.badgeProminence(archive.errors.isEmpty ? .standard : .increased)
				}
				Section {
					NavigationLink(value: "modules") {
						Label("Modules", systemImage: "cube")
							.badge(archive.modules.count)
					}
					NavigationLink(value: "classes") {
						Label("Classes", systemImage: "brain")
							.badge(archive.classes.count)
					}
					NavigationLink(value: "tags") {
						Label("Tags", systemImage: "tag")
							.badge(archive.tags.count)
					}
				}
				.badgeProminence(.decreased)
			}
#if !os(macOS)
			.navigationTitle(Text(verbatim: "\(archive.title) \(archive.version)").font(.headline))
#endif
		} detail: {
			NavigationStack(path: _navigation) {
				Group {
					switch page {
					case "metadata": MetadataPage()
					case "modules": ModulesPage()
					case "classes": ClassesPage()
					case "tags": TagsPage()
					default: ContentUnavailableView("Select something from the sidebar", systemImage: "questionmark", description: Text("View the different elements the documentation archive has to offer!"))
					}
				}
				.navigationDestination(for: ArchivedTag.self, destination: ArchivedTagView.init)
				.navigationDestination(for: ArchivedClass.self, destination: ArchivedClassView.init)
			}
		}
		#if os(macOS)
		.navigationSubtitle(Text(verbatim: "\(archive.title) \(archive.version)"))
		#endif
    }
}

#Preview {
    ContentView()
		.environment(\.archive, .latest)
}
