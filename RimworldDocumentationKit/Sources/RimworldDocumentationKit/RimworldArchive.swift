//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

import Observation

@Observable public final class RimworldArchive {

	public let metadata: RimworldArchiveMetadata

	public init(using metadata: RimworldArchiveMetadata) {
		self.metadata = metadata
	}

	public init() {
		metadata = .init()
	}

}

extension RimworldArchive: Hashable {

	public static func == (lhs: RimworldArchive, rhs: RimworldArchive) -> Bool {
		lhs === rhs
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}

}

extension RimworldArchive {

	public var attributes: AnyRandomAccessCollection<Attribute> {
		collection(using: metadata.attributes.indices, element: Attribute.init)
	}

	public var classes: AnyRandomAccessCollection<Class> {
		collection(using: metadata.classes.indices, element: Class.init)
	}

	public var definitions: AnyRandomAccessCollection<Definition> {
		collection(using: metadata.definitions.indices, element: Definition.init)
	}

	public var modules: AnyRandomAccessCollection<Module> {
		collection(using: metadata.modules.indices, element: Module.init)
	}

	public var relationships: AnyRandomAccessCollection<Relationship> {
		collection(using: metadata.relationships.indices, element: Relationship.init)
	}

	public func relationships(context: Tag?) -> AnyRandomAccessCollection<Relationship> {
		AnyRandomAccessCollection(relationships.lazy.filter { relation in
			relation.context?.id == context?.id
		})
	}

	public func relationships(parent: Tag) -> AnyRandomAccessCollection<Relationship> {
		AnyRandomAccessCollection(relationships.lazy.filter { relation in
			relation.parent.id == parent.id
		})
	}

	public func relationships(child: Tag) -> AnyRandomAccessCollection<Relationship> {
		AnyRandomAccessCollection(relationships.lazy.filter { relation in
			relation.child.id == child.id
		})
	}

	public var resources: AnyRandomAccessCollection<Resource> {
		collection(using: metadata.resources.indices, element: Resource.init)
	}

	public var tags: AnyRandomAccessCollection<Tag> {
		collection(using: metadata.tags.indices, element: Tag.init)
	}

	public var tagExamples: AnyRandomAccessCollection<TagExample> {
		collection(using: metadata.tagExamples.indices, element: TagExample.init)
	}

	private func collection<T>(using indices: Range<Int>, element: @escaping (Int, RimworldArchive) -> T) -> AnyRandomAccessCollection<T> {
		AnyRandomAccessCollection(indices.lazy.map { i in
			element(i, self)
		})
	}

}
