//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct Attribute: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension Attribute {

	public var metadata: AttributeMetadata {
		_read { yield archive.metadata.attributes[id] }
	}

	public var identifier: String {
		_read { yield metadata.identifier }
	}

	public var name: String {
		_read { yield metadata.name }
	}

	public var module: Module? {
		metadata._module.map { i in
			Module(at: i, in: archive)
		}
	}

}
