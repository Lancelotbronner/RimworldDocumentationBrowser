//
//  Preview Content.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-09.
//

import Foundation

extension RimworldDocumentationArchive {

	public static let latest: RimworldDocumentationArchive = {
		let url = Bundle.main.url(forResource: "latest", withExtension: "json")!
		let data = try! Data(contentsOf: url)
		let archive = try! JSONDecoder().decode(RimworldDocumentationArchive.self, from: data)
		return archive
	}()

}
