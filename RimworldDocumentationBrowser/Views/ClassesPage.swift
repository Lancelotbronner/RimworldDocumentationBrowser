//
//  ClassesPage.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI
import RimworldDocumentationKit

struct ClassesPage: View {
	@Environment(RimworldArchive.self) private var archive

	@State private var query = ""

	var results: AnyRandomAccessCollection<Class> {
		var tmp = archive.classes
		if !query.isEmpty {
			tmp = AnyRandomAccessCollection(tmp.lazy.filter {
				$0.identifier.contains(query)
			})
		}
		return tmp
	}

	var body: some View {
		// TODO: More Information
		// Class information along with schema and definitions.
		// TODO: Advanced Search
		// Advanced search filter, either here or in the toolbar.
		Form {
			List(results) { schema in
				ClassLink(schema)
			}
		}
		.formStyle(.grouped)
		.searchable(text: $query)
	}

}

struct ClassLabel: View {
	let schema: Class

	init(_ schema: Class) {
		self.schema = schema
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(schema.name)
			Text(schema.identifier)
				.font(.caption)
				.foregroundStyle(.secondary)
				.monospaced()
		}
	}
}

struct ClassLink: View {
	let schema: Class

	init(_ schema: Class) {
		self.schema = schema
	}

	var body: some View {
		NavigationLink(value: schema) {
			ClassLabel(schema)
		}
	}
}

struct ClassView: View {
	let schema: Class

	init(_ schema: Class) {
		self.schema = schema
	}

	var body: some View {
		Form {
			LabeledContent("Identifier", value: schema.identifier)
			LabeledContent("Name", value: schema.name)
		}
		.formStyle(.grouped)
		.navigationTitle(schema.identifier)
	}
}

#Preview("List") {
	ClassesPage()
		.environment(RimworldArchive.latest)
}

#Preview("Detail") {
	NavigationStack {
		ClassView(RimworldArchive.latest.classes.randomElement()!)
	}
}
