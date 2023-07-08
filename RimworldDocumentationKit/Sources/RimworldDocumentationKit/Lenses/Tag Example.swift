//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-08.
//

public struct TagExample: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension TagExample {

	public var metadata: TagExampleMetadata {
		_read { yield archive.metadata.tagExamples[id] }
	}

	public var value: String {
		_read { yield archive.metadata.examples[metadata._example] }
	}

	public var relationship: Relationship {
		Relationship(at: metadata._relationship, in: archive)
	}

}
