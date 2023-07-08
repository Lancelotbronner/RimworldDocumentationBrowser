//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct Definition: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension Definition {

	public var metadata: DefinitionMetadata {
		_read { yield archive.metadata.definitions[id] }
	}

	public var identifier: String {
		_read { yield metadata.identifier }
	}

}
