//
//  TagsPage.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI
import RimworldDocumentationKit

struct TagsPage: View {
	@Environment(RimworldArchive.self) private var archive

	@State private var query = ""

	var results: AnyRandomAccessCollection<Tag> {
		var tmp = archive.tags
		if !query.isEmpty {
			tmp = AnyRandomAccessCollection(tmp.lazy.filter {
				$0.identifier.contains(query)
			})
		}
		return tmp
	}

	var body: some View {
		Form {
#if DEBUG
			Section("Roadmap") {
				LabeledContent("More Information", value: "Class information along with schema and definitions.")
				LabeledContent("Advanced Search", value: "Advanced search filter, either here or in the toolbar.")
			}
#endif
			List(results) { tag in
				TagLink(tag)
			}
		}
		.formStyle(.grouped)
		.searchable(text: $query)
		.navigationTitle("Tags")
	}

}

struct TagLabel: View {
	let tag: Tag

	init(_ tag: Tag) {
		self.tag = tag
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(tag.name)
			Text(tag.identifier)
				.font(.caption)
				.foregroundStyle(.secondary)
				.monospaced()
		}
	}
}

struct TagLink: View {
	let tag: Tag

	init(_ tag: Tag) {
		self.tag = tag
	}

	var body: some View {
		NavigationLink(value: tag) {
			TagLabel(tag)
		}
	}
}

struct TagView: View {

	private let tag: Tag
	private let parents: [Tag]
	private let children: [Tag]
	private let examples: [TagExample]

	init(_ tag: Tag) {
		self.tag = tag
		parents = Array(tag.parents)
		children = Array(tag.children)
		examples = Array(tag.examples)
	}

	private var formattedParents: String {
		parents.lazy
			.map(\.identifier)
			.formatted(.list(type: .and))
	}

	private var formattedChildren: String {
		children.lazy
			.map(\.identifier)
			.formatted(.list(type: .and))
	}

	var body: some View {
		Form {
			Section("XML") {
				LabeledContent("Identifier", value: tag.identifier)
				if !parents.isEmpty {
					LabeledContent("Parents", value: formattedParents)
				}
				if !children.isEmpty {
					LabeledContent("Children", value: formattedChildren)
				}
			}
			if !parents.isEmpty {
				Section("Parents") {
					List(parents) { parent in
						TagLink(parent)
					}
				}
			}
			if !children.isEmpty {
				Section("Children") {
					List(children) { child in
						TagLink(child)
					}
				}
			}
			if !examples.isEmpty {
				Section("Examples") {
					List(parents) { parent in
						Section(parent.identifier) {
							ForEach(examplesOf(parent: parent)) { example in
								Text(example.value)
							}
						}
					}
				}
				.monospaced()
			}
		}
		.formStyle(.grouped)
		.navigationTitle(tag.name)
	}

	private func examplesOf(parent: Tag) -> [TagExample] {
		let distinct = Set(examples.lazy.filter {
			$0.relationship.parent.id == parent.id
		})
		return Array(distinct)
	}

}

struct TagExamplesView: View {

	private let examples: [TagExample]
	private let contexts: [Tag]
	private let defaultContext: [Tag]

	init(_ examples: [TagExample]) {
		self.examples = examples
		let distinct = Set(examples.compactMap(\.relationship.context))
		contexts = Array(distinct)
		defaultContext = examples.lazy.filter {
			$0.relationship.context == nil
		}.map(\.relationship.parent)
	}

	private func parents(of context: Tag?) -> [Tag] {
		let distinct = Set(examples.lazy.filter {
			$0.relationship.context?.id == context?.id
		}.map(\.relationship.parent))
		return Array(distinct)
	}

	private func examples(of context: Tag?, _ parent: Tag) -> [TagExample] {
		let distinct = Set(examples.lazy.filter {
			$0.relationship.context?.id == context?.id
			&& $0.relationship.parent.id == parent.id
		})
		return Array(distinct)
	}

	var body: some View {
		Section("Examples") {
			if !defaultContext.isEmpty {
				List(defaultContext) { parent in
					Section(parent.identifier) {
						ForEach(examples(of: nil, parent)) { example in
							Text(example.value)
						}
					}
				}
			}
			ForEach(contexts) { context in
				Section(context.identifier) {
					List(parents(of: context)) { parent in
						Section(parent.identifier) {
							ForEach(examples(of: context, parent)) { example in
								Text(example.value)
							}
						}
					}
				}
			}
		}
	}

}

#Preview("List") {
	TagsPage()
		.environment(RimworldArchive.latest)
}

#Preview("Detail") {
	NavigationStack {
		TagView(RimworldArchive.latest.tags.randomElement()!)
	}
}
