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
			.sorted(using: SortDescriptor(\.name))
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
		.formStyle(.grouped)
		.searchable(text: $search)
		.navigationTitle("Tags")
	}

}

struct ArchivedTagView: View {
	let tag: ArchivedTag

	var body: some View {
		Form {
			Section("XML") {
				LabeledContent("Identifier", value: tag.id)
				LabeledContent("Parents", value: tag.formattedParents)
				LabeledContent("Children", value: tag.formattedChildren)
			}
			ForEach(tag.contexts) { context in
				Section(context.parent) {
					LabeledContent("Examples") {
						List(context.examples, id: \.self) { example in
							Text(example)
						}
						.monospaced()
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
