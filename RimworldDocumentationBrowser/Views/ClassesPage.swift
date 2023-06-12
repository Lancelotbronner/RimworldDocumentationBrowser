//
//  ClassesPage.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI

struct ClassesPage: View {
	@Environment(\.archive) private var archive

	@State private var search = ""

	private var classes: [ArchivedClass] {
		var result = AnyRandomAccessCollection(archive.classes)
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
			List(classes) { schema in
			}
			ArchivedClassLink(schema)
		}
		.formStyle(.grouped)
		.searchable(text: $search)
	}

}

struct ArchivedClassLink: View {
	let schema: ArchivedClass

	init(_ schema: ArchivedClass) {
		self.schema = schema
	}

	var body: some View {
		NavigationLink(value: schema) {
			VStack(alignment: .leading) {
				Text(schema.name)
				Text(schema.id)
					.font(.caption)
					.foregroundStyle(.secondary)
					.monospaced()
			}
		}
	}
}

struct ArchivedClassView: View {
	let schema: ArchivedClass

	var body: some View {
		Form {
			Section("XML") {
				LabeledContent("Identifier", value: schema.id)
			}
		}
		.formStyle(.grouped)
		.navigationTitle(schema.name)
	}
}

#Preview("List") {
	ClassesPage()
		.environment(\.archive, .latest)
}

#Preview("Detail") {
	NavigationStack {
		ArchivedClassView(schema: RimworldDocumentationArchive.latest.classes.randomElement()!)
	}
}
