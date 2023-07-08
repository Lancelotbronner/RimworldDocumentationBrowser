//
//  ModulePage.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI
import RimworldDocumentationKit

struct ModulesPage: View {
	@Environment(RimworldArchive.self) private var archive

	@State private var query = ""

	var results: AnyRandomAccessCollection<Module> {
		var tmp = archive.modules
		if !query.isEmpty {
			tmp = AnyRandomAccessCollection(tmp.lazy.filter {
				$0.identifier.contains(query)
			})
		}
		return tmp
	}

	var body: some View {
		//TODO: More Information
		// Module information along with its classes, tags and definitions declared within.
		Form {
			List(results) { module in
				ModuleLink(module)
			}
		}
		.formStyle(.grouped)
		.searchable(text: $query)
	}

}

struct ModuleLabel: View {
	private let module: Module

	init(_ module: Module) {
		self.module = module
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(module.name)
			Text(module.identifier)
				.font(.caption)
				.foregroundStyle(.secondary)
				.monospaced()
		}
	}
}

struct ModuleLink: View {
	private let module: Module

	init(_ module: Module) {
		self.module = module
	}

	var body: some View {
		NavigationLink(value: module) {
			ModuleLabel(module)
		}
	}
}

struct ModuleView: View {
	private let module: Module

	init(_ module: Module) {
		self.module = module
	}

	var body: some View {
		Form {
			LabeledContent("Identifier", value: module.identifier)
			LabeledContent("Name", value: module.name)
			LabeledContent("Version", value: module.version ?? "null")
				.foregroundStyle(.secondary)
			Toggle("Official", isOn: .constant(module.isOfficial))
				.disabled(true)
		}
		.formStyle(.grouped)
		.navigationTitle(module.identifier)
	}
}

#Preview {
	ModulesPage()
		.environment(RimworldArchive.latest)
}
