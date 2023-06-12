//
//  ModulePage.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI

struct ModulesPage: View {
	@Environment(\.archive) private var archive

	var body: some View {
		Form {
#if DEBUG
			Section("Roadmap") {
				LabeledContent("More Information", value: "Module information along with its classes, tags and definitions declared within.")
			}
#endif
			ForEach(archive.modules.keys.sorted(), id: \.self) { key in
				Section(key) {
					LabeledContent("Type", value: "Core")
				}
			}
		}
		.formStyle(.grouped)
	}
	
}

#Preview {
	ModulesPage()
		.environment(\.archive, .latest)
}
