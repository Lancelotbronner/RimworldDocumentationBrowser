//
//  Navigation.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-07-02.
//

import SwiftUI

struct Router: View {
	private let route: Route

	public init(to route: Route) {
		self.route = route
	}

	var body: some View {
		switch route {
		case .modules: ModulesPage()
		case .issues: Text("Issues")
		case .tags: TagsPage()
		case .classes: ClassesPage()
		case .attributes: Text("Attributes")
		case .definitions: Text("Definitions")
		case .resources: Text("Resources")
		}
	}
	
}

@Observable public final class Navigation {

	public var path = NavigationPath()
	public var route: Route? = nil

}

public enum Route: String {
	case modules
	case issues

	case tags
	case classes
	case attributes

	case definitions
	case resources
}
