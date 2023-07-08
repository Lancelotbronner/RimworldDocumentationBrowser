//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct Relationship: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension Relationship {

	public var metadata: RelationshipMetadata {
		_read { yield archive.metadata.relationships[id] }
	}

	public var parent: Tag {
		Tag(at: metadata._parent, in: archive)
	}

	public var child: Tag {
		Tag(at: metadata._child, in: archive)
	}

	public var context: Tag? {
		metadata._context.map { i in
			Tag(at: i, in: archive)
		}
	}

	public var examples: AnyRandomAccessCollection<TagExample> {
		AnyRandomAccessCollection(archive.tagExamples.lazy.filter {
			$0.relationship.id == id
		})
	}

}
