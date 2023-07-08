//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct Tag: Identifiable, Hashable {

	public let id: Int
	public let archive: RimworldArchive

	internal init(at index: Int, in archive: RimworldArchive) {
		id = index
		self.archive = archive
	}

}

extension Tag {

	public var metadata: TagMetadata {
		_read { yield archive.metadata.tags[id] }
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

	public var parents: AnyRandomAccessCollection<Tag> {
		let distinct = Set(archive.relationships(child: self).map(\.parent))
		return AnyRandomAccessCollection(Array(distinct))
	}

	public var children: AnyRandomAccessCollection<Tag> {
		let distinct = Set(archive.relationships(parent: self).map(\.child))
		return AnyRandomAccessCollection(Array(distinct))
	}

	public var examples: AnyRandomAccessCollection<TagExample> {
		AnyRandomAccessCollection(archive.tagExamples.lazy.filter {
			$0.relationship.child.id == id
		})
	}

}
