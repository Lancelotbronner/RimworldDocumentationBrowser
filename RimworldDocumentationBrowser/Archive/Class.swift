//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2023-06-07.
//

public struct ArchivedClass: Hashable, Identifiable {
	
	private let archive: RimworldDocumentationArchive
	private var i: Dictionary<String, _ArchivedClass>.Index

	internal init(at index: Dictionary<String, _ArchivedClass>.Index, in archive: RimworldDocumentationArchive) {
		self.archive = archive
		i = index
	}
	
	internal init?(_ name: String, in archive: RimworldDocumentationArchive) {
		guard let index = archive._classes.index(forKey: name) else {
			return nil
		}
		self.init(at: index, in: archive)
	}

	internal var rawValue: _ArchivedClass {
		_read { yield archive._classes.values[i] }
		nonmutating _modify { yield &archive._classes.values[i] }
	}

	public var id: String {
		_read { yield archive._classes.keys[i] }
		set {
			let (key, value) = archive._classes[i]
			archive._classes[newValue] = value
			archive._classes.removeValue(forKey: key)
		}
	}

	public var name: String {
		_read {
			if rawValue.name == nil {
				rawValue.name(using: id)
			}
			yield rawValue.name!
		}
	}

	public static func == (lhs: ArchivedClass, rhs: ArchivedClass) -> Bool {
		ObjectIdentifier(lhs.archive) == ObjectIdentifier(rhs.archive) && lhs.i == rhs.i
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(archive))
		hasher.combine(i)
	}

}
