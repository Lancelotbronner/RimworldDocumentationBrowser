//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct AttributeExampleMetadata: Hashable, Decodable {
	public let _example: Int
	public let _tag: Int
	public let _attribute: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_example = try container.decode(Int.self)
		_tag = try container.decode(Int.self)
		_attribute = try container.decode(Int.self)
	}
}

public struct AttributeUsageMetadata: Hashable, Decodable {
	public let _example: Int
	public let _definition: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_example = try container.decode(Int.self)
		_definition = try container.decode(Int.self)
	}
}

public struct AttributeMetadata: Hashable, Decodable {
	public let identifier: String
	public let name: String
	public let _module: Int?

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		identifier = try container.decode(String.self)
		name = try container.decode(String.self)
		_module = try container.decode(Int?.self)
	}
}

public struct ClassMetadata: Hashable, Decodable {
	public let identifier: String
	public let name: String
	public let _module: Int?

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		identifier = try container.decode(String.self)
		name = try container.decode(String.self)
		_module = try container.decode(Int?.self)
	}
}

public struct DefinitionMetadata: Hashable, Decodable {
	public let identifier: String
	public let abstract: Bool
	public let _parent: Int?
	public let _class: Int
	public let _module: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		identifier = try container.decode(String.self)
		abstract = try container.decode(Bool.self)
		_parent = try container.decode(Int?.self)
		_class = try container.decode(Int.self)
		_module = try container.decode(Int.self)
	}
}

public struct IssueMetadata: Hashable, Decodable {
	public let severity: UInt8
	public let message: String

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		severity = try container.decode(UInt8.self)
		message = try container.decode(String.self)
	}
}

public struct ModuleMetadata: Hashable, Decodable {
	public let identifier: String
	public let name: String
	public let version: String?
	public let official: Bool

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		identifier = try container.decode(String.self)
		name = try container.decode(String.self)
		version = try container.decode(String?.self)
		official = try container.decode(Bool.self)
	}
}

public struct RelationshipMetadata: Hashable, Decodable {
	public let _parent: Int
	public let _child: Int
	public let _context: Int?

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_parent = try container.decode(Int.self)
		_child = try container.decode(Int.self)
		_context = try container.decode(Int?.self)
	}
}

public struct ResourceMetadata: Hashable, Decodable {
	public let path: String
	public let _module: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		path = try container.decode(String.self)
		_module = try container.decode(Int.self)
	}
}

public struct TagExampleMetadata: Hashable, Decodable {
	public let _example: Int
	public let _relationship: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_example = try container.decode(Int.self)
		_relationship = try container.decode(Int.self)
	}
}

public struct TagUsageMetadata: Hashable, Decodable {
	public let _example: Int
	public let _definition: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_example = try container.decode(Int.self)
		_definition = try container.decode(Int.self)
	}
}

public struct TagMetadata: Hashable, Decodable {
	public let identifier: String
	public let name: String
	public let _module: Int?

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		identifier = try container.decode(String.self)
		name = try container.decode(String.self)
		_module = try container.decode(Int?.self)
	}
}
