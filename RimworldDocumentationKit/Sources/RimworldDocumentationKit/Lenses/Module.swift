//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct Module: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension Module {

	public var metadata: ModuleMetadata {
		_read { yield archive.metadata.modules[id] }
	}

	public var identifier: String {
		_read { yield metadata.identifier }
	}

	public var name: String {
		_read { yield metadata.name }
	}

	public var version: String? {
		_read { yield metadata.version }
	}

	public var isOfficial: Bool {
		_read { yield metadata.official }
	}

}
