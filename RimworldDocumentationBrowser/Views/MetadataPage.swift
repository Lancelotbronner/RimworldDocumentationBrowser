////
////  MetadataPage.swift
////  RimworldDocumentationBrowser
////
////  Created by Christophe Bronner on 2023-06-07.
////
//
//import SwiftUI
//import RimworldDocumentationKit
//
//struct MetadataPage: View {
//	@Environment(RimworldArchive.self) private var archive
//
//	var body: some View {
//		Form {
//			Section("Archive") {
//				LabeledContent("Title", value: archive.title)
//				LabeledContent("Version", value: archive.version)
//			}
//
//			if !archive.errors.isEmpty {
//				Section("Errors") {
//					List(archive.errors, id: \.self) { error in
//						Text(error)
//					}
//					.foregroundStyle(.red)
//					.monospaced()
//				}
//			}
//
//			if !archive.warnings.isEmpty {
//				Section("Warnings") {
//					List(archive.warnings, id: \.self) { warning in
//						Text(warning)
//					}
//					.foregroundStyle(.yellow)
//					.monospaced()
//				}
//			}
//		}
//		.formStyle(.grouped)
//	}
//
//}
//
//#Preview {
//	MetadataPage()
//		.environment(RimworldArchive.latest)
//}
