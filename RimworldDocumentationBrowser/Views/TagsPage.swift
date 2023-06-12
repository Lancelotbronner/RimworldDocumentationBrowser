//
//  TagsPage.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI

struct TagsPage: View {
	@Environment(\.archive) private var archive

	@State private var search = ""

	private var tags: [ArchivedTag] {
		var result = AnyRandomAccessCollection(archive.tags)
		if !search.isEmpty {
			result = AnyRandomAccessCollection(result.filter {
				$0.id.contains(search)
			})
		}
		return result
			.sorted(using: SortDescriptor(\.id))
	}

	var body: some View {
		Form {
#if DEBUG
			Section("Roadmap") {
				LabeledContent("More Information", value: "Class information along with schema and definitions.")
				LabeledContent("Advanced Search", value: "Advanced search filter, either here or in the toolbar.")
			}
#endif
			List(tags) { tag in
			}
			ArchivedTagLink(tag)
		}
		.formStyle(.grouped)
		.searchable(text: $search)
		.navigationTitle("Tags")
	}

}

struct ArchivedTagLink: View {
	let tag: ArchivedTag

	init(_ tag: ArchivedTag) {
		self.tag = tag
	}

	var body: some View {
		NavigationLink(value: tag) {
			VStack(alignment: .leading) {
				Text(tag.name)
				Text(tag.id)
					.font(.caption)
					.foregroundStyle(.secondary)
					.monospaced()
			}
		}
	}
}

struct ArchivedTagView: View {
	let tag: ArchivedTag

	var body: some View {
		Form {
			Section("XML") {
				LabeledContent("Identifier", value: tag.id)
				if !tag.formattedParents.isEmpty {
					LabeledContent("Parents", value: tag.formattedParents)
				}
				if !tag.formattedChildren.isEmpty {
					LabeledContent("Children", value: tag.formattedChildren)
				}
			}
			if tag.hasNavigation {
				Section("Navigation") {
					List {
						if !tag.parents.isEmpty {
							Section("Parents") {
								ForEach(tag.parents) { parent in
									ArchivedTagLink(parent)
								}
							}
						}
						if !tag.children.isEmpty {
							Section("Children") {
								ForEach(tag.children) { parent in
									ArchivedTagLink(parent)
								}
							}
						}
					}
				}
			}
			if tag.hasExamples {
				Section("Examples") {
					List(tag.contexts) { context in
						Section {
							ForEach(context.examples, id: \.self) { example in
								Text(example)
							}
							.monospaced()
						} header: {
							Text(context.id).monospaced()
						}
					}
				}
			}
		}
		.formStyle(.grouped)
		.navigationTitle(tag.name)
	}
}

#Preview("List") {
	TagsPage()
		.environment(\.archive, .latest)
}

#Preview("Detail") {
	NavigationStack {
		ArchivedTagView(tag: RimworldDocumentationArchive.latest.tags.randomElement()!)
	}
}
