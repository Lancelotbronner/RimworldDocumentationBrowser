//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-06-07.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
import SwiftUI
import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, *)
extension UTType {

	public static let rimworldDocumentationArchive = UTType(exportedAs: "com.lancelotbronner.rimworld.documentation.archive", conformingTo: .json)

}

@available(macOS 11.0, iOS 14.0, *)
public struct RimworldDocumentationArchiveDocument: FileDocument {

	public static let readableContentTypes = [UTType.json]

	public let archive: RimworldDocumentationArchive

	public init(_ archive: RimworldDocumentationArchive) {
		self.archive = archive
	}

	public init(configuration: ReadConfiguration) throws {
		guard configuration.file.isRegularFile, let data = configuration.file.regularFileContents else {
			throw CocoaError(.coderReadCorrupt)
		}

		archive = try JSONDecoder().decode(RimworldDocumentationArchive.self, from: data)
	}

	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
		return try configuration.existingFile ?? FileWrapper(regularFileWithContents: try encoder.encode(archive))
	}

}
#endif
