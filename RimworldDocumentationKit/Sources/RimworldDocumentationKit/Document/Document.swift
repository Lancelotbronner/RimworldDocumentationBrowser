//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
import SwiftUI
import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, *)
extension UTType {

	public static let rimworldArchive = UTType(exportedAs: "com.lancelotbronner.rimworld.documentation.archive", conformingTo: .json)

}

@available(macOS 11.0, iOS 14.0, *)
public struct RimworldArchiveDocument: FileDocument {

	public static let readableContentTypes = [UTType.json]

	public let archive: RimworldArchive

	public init(_ archive: RimworldArchive) {
		self.archive = archive
	}

	public init(configuration: ReadConfiguration) throws {
		guard configuration.file.isRegularFile, let data = configuration.file.regularFileContents else {
			throw CocoaError(.coderReadCorrupt)
		}

		let metadata = try JSONDecoder().decode(RimworldArchiveMetadata.self, from: data)
		guard metadata.format == 1 else {
			throw CocoaError(.coderInvalidValue)
		}

		archive = RimworldArchive(using: metadata)
	}

	public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//		let data = try JSONEncoder().encode(archive.metadata)
//		return FileWrapper(regularFileWithContents: data)
		return FileWrapper()
	}

}
#endif

