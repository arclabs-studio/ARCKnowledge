//
//  ARCAgentsDocsTests.swift
//  ARCAgentsDocs
//
//  Created by ARC Labs Studio on 11/12/2025.
//

import Testing
import Foundation
@testable import ARCAgentsDocs

@Suite("ARCAgentsDocs Tests")
struct ARCAgentsDocsTests {

    // MARK: - Documentation Loading Tests

    @Test("Load CLAUDE.md documentation")
    func loadClaudeMd() throws {
        let content = try ARCAgentsDocs.loadDocumentation(at: "CLAUDE.md")
        #expect(!content.isEmpty)
        #expect(content.contains("ARC Labs Studio"))
    }

    @Test("Load Architecture documentation")
    func loadArchitectureDocumentation() throws {
        let cleanArch = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Architecture/clean-architecture.md")
        #expect(!cleanArch.isEmpty)

        let mvvm = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Architecture/mvvm-c.md")
        #expect(!mvvm.isEmpty)
    }

    @Test("Load Quality documentation")
    func loadQualityDocumentation() throws {
        let testing = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Quality/testing.md")
        #expect(!testing.isEmpty)

        let codeReview = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Quality/code-review.md")
        #expect(!codeReview.isEmpty)
    }

    // MARK: - Document URL Tests

    @Test("Get document URL")
    func getDocumentURL() throws {
        let url = try ARCAgentsDocs.documentURL(for: "CLAUDE.md")
        #expect(url.pathExtension == "md")
    }

    @Test("Get document URL throws for non-existent file")
    func getDocumentURLThrowsForNonExistentFile() {
        #expect(throws: DocumentationError.self) {
            _ = try ARCAgentsDocs.documentURL(for: "NonExistent.md")
        }
    }

    // MARK: - Category Tests

    @Test("Available categories contains expected values")
    func availableCategories() {
        let categories = ARCAgentsDocs.availableCategories
        #expect(categories.contains(.architecture))
        #expect(categories.contains(.quality))
        #expect(categories.contains(.workflow))
        #expect(categories.count == 6)
    }

    @Test("List documents in Architecture category")
    func listDocumentsInArchitecture() throws {
        let docs = try ARCAgentsDocs.listDocuments(in: .architecture)
        #expect(!docs.isEmpty)
        #expect(docs.contains("clean-architecture.md"))
        #expect(docs.contains("mvvm-c.md"))
    }

    @Test("List documents in Quality category")
    func listDocumentsInQuality() throws {
        let docs = try ARCAgentsDocs.listDocuments(in: .quality)
        #expect(!docs.isEmpty)
        #expect(docs.contains("testing.md"))
        #expect(docs.contains("code-review.md"))
    }

    // MARK: - Error Handling Tests

    @Test("Loading non-existent file throws fileNotFound error")
    func loadNonExistentFileThrows() {
        #expect(throws: DocumentationError.self) {
            _ = try ARCAgentsDocs.loadDocumentation(at: "NonExistent/file.md")
        }
    }

    // MARK: - Category Description Tests

    @Test("Category descriptions are not empty")
    func categoryDescriptions() {
        for category in ARCAgentsDocs.DocumentCategory.allCases {
            #expect(!category.description.isEmpty)
        }
    }
}
