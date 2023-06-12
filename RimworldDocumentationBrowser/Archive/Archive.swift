//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-06-06.
//

public final class RimworldDocumentationArchive: Codable, CustomStringConvertible {

	public init(_ title: String, version: String) {
		metadata = ArchiveMetadata(title: title, version: version)
	}

	public var description: String {
		"\(title) \(version) (\(warnings.count) warnings, \(errors.count) errors) of \(modules.count) modules, \(classes.count) classes and \(_tags.count) tags"
	}

	//MARK: - Metadata Management

	internal var metadata: ArchiveMetadata

	internal struct ArchiveMetadata: Codable {
		var title: String
		var version: String
		var warnings: [String]
		var errors: [String]

		init(title: String, version: String, warnings: [String] = [], errors: [String] = []) {
			self.title = title
			self.version = version
			self.warnings = warnings
			self.errors = errors
		}

		init(from decoder: Decoder) throws {
			let container: KeyedDecodingContainer<RimworldDocumentationArchive.ArchiveMetadata.CodingKeys> = try decoder.container(keyedBy: RimworldDocumentationArchive.ArchiveMetadata.CodingKeys.self)
			self.title = try container.decode(String.self, forKey: RimworldDocumentationArchive.ArchiveMetadata.CodingKeys.title)
			self.version = try container.decode(String.self, forKey: RimworldDocumentationArchive.ArchiveMetadata.CodingKeys.version)
			self.warnings = try container.decodeIfPresent([String].self, forKey: RimworldDocumentationArchive.ArchiveMetadata.CodingKeys.warnings) ?? []
			self.errors = try container.decodeIfPresent([String].self, forKey: RimworldDocumentationArchive.ArchiveMetadata.CodingKeys.errors) ?? []
		}
	}

	public var title: String {
		_read { yield metadata.title }
		_modify { yield &metadata.title }
	}

	public var version: String {
		_read { yield metadata.version }
		_modify { yield &metadata.version }
	}

	public var warnings: [String] {
		_read { yield metadata.warnings }
		_modify { yield &metadata.warnings }
	}

	public var errors: [String] {
		_read { yield metadata.errors }
		_modify { yield &metadata.errors }
	}

	//MARK: - Module Management

	public var modules: [String : ArchivedModule] = [:]

	//MARK: - Class Management

	internal var _classes: [String : _ArchivedClass] = [:]

	public lazy var classes: [ArchivedClass] = {
		_classes.indices.lazy.map {
			ArchivedClass(at: $0, in: self)
		}
	}()

	//MARK: - Tag Management

	internal var _tags: [String : _ArchivedTag] = [:]

	public lazy var tags: [ArchivedTag] = {
		_tags.indices.map { ArchivedTag(at: $0, in: self) }
	}()

	//MARK: - Template Management

	//MARK: - Definition Management

	//MARK: - Codable Management

	enum CodingKeys: String, CodingKey {
		case metadata
		case modules
		case _classes = "classes"
		case _tags = "tags"
	}

}

public struct ArchivedModule: Codable, Hashable { }

internal struct _ArchivedClass: Codable {

	var name: String?

	@inlinable mutating func name(using identifier: String) {
		var result = identifier
		if result.hasSuffix("Def") {
			result.removeLast(3)
		}
		result.titleCase()
		name = result
	}

	init(from decoder: Decoder) throws {

	}

}

internal struct _ArchivedTag: Codable {
	var children: [String]
	var contexts: [String : _ArchivedTagContext]

	var name: String?

	lazy var formattedChildren: String = {
		children.formatted()
	}()

	lazy var formattedParents: String = {
		contexts.keys.formatted()
	}()

	lazy var formattedExamples: String = {
		Set(contexts.values.flatMap(\.examples)).formatted()
	}()

	@inlinable mutating func name(using identifier: String) {
		var result = identifier.titleCased
		result.replace(/Tex\b/, with: "Texture")
		result.replace(/Def\b/, with: "Definition")
		name = result.titleCased
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.children = try container.decodeIfPresent([String].self, forKey: .children) ?? []
		self.contexts = try container.decodeIfPresent([String : _ArchivedTagContext].self, forKey: .contexts) ?? [:]
	}
}

internal struct _ArchivedTagContext: Codable {
	var examples: [String]
	var usage: [String : OneOrMore<Int>]

	lazy var formattedExamples: String = {
		Set(examples).formatted()
	}()

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.examples = try container.decodeIfPresent([String].self, forKey: .examples) ?? []
		self.usage = try container.decodeIfPresent([String : OneOrMore<Int>].self, forKey: .usage) ?? [:]
	}
}

internal enum OneOrMore<T: Codable>: Codable, Sequence, CustomDebugStringConvertible {
	case one(T)
	case more([T])

	func makeIterator() -> AnyIterator<T> {
		switch self {
		case let .one(value): return AnyIterator(CollectionOfOne(value).makeIterator())
		case let .more(values): return AnyIterator(values.makeIterator())
		}
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(T.self) {
			self = .one(value)
		} else {
			self = .more(try container.decode([T].self))
		}
	}

	var debugDescription: String {
		switch self {
		case let .one(value): return String(describing: value)
		case let .more(values): return values.description
		}
	}
}
