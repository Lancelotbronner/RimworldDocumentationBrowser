//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct Resource: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension Resource {

	public var metadata: ResourceMetadata {
		_read { yield archive.metadata.resources[id] }
	}

	public var path: String {
		_read { yield metadata.path }
	}

	public var module: Module {
		Module(at: metadata._module, in: archive)
	}

}
