//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-06-06.
//

public struct ArchivedTag: Hashable, Identifiable {
	
	private let archive: RimworldDocumentationArchive
	private var i: Dictionary<String, _ArchivedTag>.Index

	internal init(at index: Dictionary<String, _ArchivedTag>.Index, in archive: RimworldDocumentationArchive) {
		self.archive = archive
		i = index
	}

	internal init?(_ name: String, in archive: RimworldDocumentationArchive) {
		guard let index = archive._tags.index(forKey: name) else {
			return nil
		}
		self.init(at: index, in: archive)
	}

	public var id: String {
		_read { yield archive._tags.keys[i] }
		set {
			let (key, value) = archive._tags[i]
			archive._tags[newValue] = value
			archive._tags.removeValue(forKey: key)
		}
	}

	internal var rawValue: _ArchivedTag {
		_read { yield archive._tags.values[i] }
		nonmutating _modify { yield &archive._tags.values[i] }
	}

	public var name: String {
		_read {
			if rawValue.name == nil {
				rawValue.name(using: id)
			}
			yield rawValue.name!
		}
	}

	public var hasSingleParent: Bool {
		rawValue.contexts.count == 1
	}

	public var parents: some RandomAccessCollection<ArchivedTag> {
		rawValue.contexts.keys.lazy.compactMap { ArchivedTag($0, in: archive) }
	}

	public var formattedParents: String {
		_read { yield rawValue.formattedParents }
	}

	public var children: some RandomAccessCollection<ArchivedTag> {
		rawValue.children.lazy.compactMap { ArchivedTag($0, in: archive) }
	}

	public var formattedChildren: String {
		_read { yield rawValue.formattedChildren }
	}

	public var contexts: some RandomAccessCollection<ArchivedTagContext> {
		rawValue.contexts.indices.lazy.map { ArchivedTagContext(at: $0, in: self) }
	}

	public func context(of parent: String) -> ArchivedTagContext? {
		guard let index = rawValue.contexts.index(forKey: parent) else {
			return nil
		}
		return ArchivedTagContext(at: index, in: self)
	}

	public var formattedExamples: String {
		_read { yield rawValue.formattedExamples }
	}

	public var usage: some RandomAccessCollection<ArchivedUsage> {
		contexts.flatMap(\.usage)
	}

	public static func == (lhs: ArchivedTag, rhs: ArchivedTag) -> Bool {
		ObjectIdentifier(lhs.archive) == ObjectIdentifier(rhs.archive) && lhs.i == rhs.i
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(archive))
		hasher.combine(i)
	}

}

public struct ArchivedTagContext: Identifiable {
	internal var tag: ArchivedTag
	internal let i: Dictionary<String, _ArchivedTagContext>.Index

	init(at index: Dictionary<String, _ArchivedTagContext>.Index, in tag: ArchivedTag) {
		self.tag = tag
		i = index
	}

	internal var rawValue: _ArchivedTagContext {
		_read { yield tag.rawValue.contexts.values[i] }
		nonmutating _modify { yield &tag.rawValue.contexts.values[i] }
	}

	public var id: String {
		_read { yield parent }
	}

	public var parent: String {
		_read { yield tag.rawValue.contexts.keys[i] }
	}

	public var examples: some RandomAccessCollection<String> {
		rawValue.examples
	}

	public var formattedExample: String {
		_read { yield rawValue.formattedExamples }
	}

	public var usage: some RandomAccessCollection<ArchivedUsage> {
		rawValue.usage.indices.lazy.flatMap { i in
			rawValue.usage.values[i].map { e in
				ArchivedUsage(at: i, example: e, in: self)
			}
		}
	}

}

public struct ArchivedUsage {
	internal var context: ArchivedTagContext
	internal let i: Dictionary<String, OneOrMore<Int>>.Index
	internal let e: Int

	internal init(at index: Dictionary<String, OneOrMore<Int>>.Index, example: Int, in context: ArchivedTagContext) {
		self.context = context
		i = index
		e = example
	}

	internal var key: String {
		_read { yield context.rawValue.usage.keys[i] }
	}

	public var type: Substring {
		_read { yield key.prefix(upTo: key.firstIndex(of: " ")!) }
	}

	public var definition: Substring {
		_read { yield key.suffix(from: key.index(after: key.lastIndex(of: " ")!)) }
	}

	internal var indices: OneOrMore<Int> {
		_read { yield context.rawValue.usage.values[i] }
	}

	public var example: String {
		_read { yield context.rawValue.examples[e] }
		_modify {
			//TODO: Check and merge the new value
			// - If it already exists, reuse it
			// - If others are using this index, add it to a new index
			// - If its the only usage with this example, change the example
			yield &context.rawValue.examples[e]
		}
	}
}
