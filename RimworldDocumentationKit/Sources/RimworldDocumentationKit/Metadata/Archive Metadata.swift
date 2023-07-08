//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-07-02.
//

public struct RimworldArchiveMetadata {

	public var format: Int = 1
	public var attributeExamples: [AttributeExampleMetadata] = []
	public var attributeUsage: [AttributeUsageMetadata] = []
	public var attributes: [AttributeMetadata] = []
	public var classes: [ClassMetadata] = []
	public var definitions: [DefinitionMetadata] = []
	public var examples: [String] = []
	public var issues: [IssueMetadata] = []
	public var modules: [ModuleMetadata] = []
	public var relationships: [RelationshipMetadata] = []
	public var resources: [ResourceMetadata] = []
	public var tagExamples: [TagExampleMetadata] = []
	public var tagUsage: [TagUsageMetadata] = []
	public var tags: [TagMetadata] = []

	private enum CodingKeys: String, CodingKey {
		case format
		case attributeExamples = "attribute-examples"
		case attributeUsage = "attribute-usage"
		case attributes
		case classes
		case definitions
		case examples
		case issues
		case modules
		case relationships
		case resources
		case tagExamples = "tag-examples"
		case tagUsage = "tag-usage"
		case tags
	}

}

extension RimworldArchiveMetadata: Decodable { }
