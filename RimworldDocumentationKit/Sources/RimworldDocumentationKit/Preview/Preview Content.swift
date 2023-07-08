//
//  Preview Content.swift
//  RimworldDocumentationBrowser
//
//  Created by Christophe Bronner on 2023-06-09.
//

#if canImport(Foundation)
import Foundation

extension RimworldArchive {

	public static let latest: RimworldArchive = {
		let url = Bundle.module.url(forResource: "latest", withExtension: "json")!
		let data = try! Data(contentsOf: url)
		let metadata = try! JSONDecoder().decode(RimworldArchiveMetadata.self, from: data)
		return RimworldArchive(using: metadata)
	}()

}
#endif
