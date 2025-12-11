//
//  ARCAgentsDocs.swift
//  ARCAgentsDocs
//
//  Created by ARC Labs Studio on 11/12/2025.
//

import Foundation

/// A centralized documentation package for AI agents working on ARC Labs Studio projects.
///
/// `ARCAgentsDocs` provides programmatic access to ARC Labs Studio's development guidelines,
/// architectural standards, and best practices. This package is designed primarily for AI agents
/// (like Claude Code) to access contextual information during development.
///
/// ## Package Structure
///
/// This is a documentation-only package. All markdown files are located in the repository root:
/// - `CLAUDE.md` - Main entry point for AI agents
/// - `Documentation/` - Organized documentation by category
///
/// ## Topics
///
/// ### Getting Documentation
/// - ``loadDocumentation(at:)``
/// - ``documentURL(for:)``
/// - ``packageRootURL``
///
/// ### Exploring Available Documentation
/// - ``availableCategories``
/// - ``DocumentCategory``
///
/// ## Example Usage
///
/// ```swift
/// // Load the main Claude.md entry point
/// let claudeDoc = try ARCAgentsDocs.loadDocumentation(at: "CLAUDE.md")
///
/// // Get URL to a specific architecture document
/// let cleanArchURL = try ARCAgentsDocs.documentURL(for: "Documentation/Architecture/clean-architecture.md")
///
/// // List all documentation categories
/// let categories = ARCAgentsDocs.availableCategories
/// ```
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum ARCAgentsDocs: Sendable {

    // MARK: Public Types

    /// Documentation categories available in the package.
    public enum DocumentCategory: String, CaseIterable, Sendable {
        case architecture = "Architecture"
        case layers = "Layers"
        case projects = "Projects"
        case quality = "Quality"
        case tools = "Tools"
        case workflow = "Workflow"

        /// Human-readable description of the category.
        public var description: String {
            switch self {
            case .architecture:
                return "Architectural patterns and principles (Clean Architecture, MVVM+C, SOLID, Protocol-Oriented)"
            case .layers:
                return "Implementation layer guidelines (Presentation, Domain, Data)"
            case .projects:
                return "Project type guidelines (Apps, Packages)"
            case .quality:
                return "Quality assurance standards (Code Review, Testing, Documentation, Code Style)"
            case .tools:
                return "Development tools integration (ARCDevTools, SPM, Xcode)"
            case .workflow:
                return "Development workflow (Git Branches, Commits, Plan Mode)"
            }
        }
    }

    // MARK: Public Properties

    /// Returns the root URL of the package repository.
    ///
    /// This URL points to the root directory where the package is located,
    /// allowing access to documentation files in their original location.
    ///
    /// - Note: This URL is determined at runtime by finding the Package.swift file.
    public static var packageRootURL: URL {
        // Start from the source file location
        let sourceFileURL = URL(fileURLWithPath: #file)

        // Navigate up from the source file to find Package.swift
        var currentURL = sourceFileURL.deletingLastPathComponent()

        // Keep going up until we find Package.swift or reach root
        while currentURL.path != "/" {
            let packageSwiftURL = currentURL.appendingPathComponent("Package.swift")
            if FileManager.default.fileExists(atPath: packageSwiftURL.path) {
                return currentURL
            }
            currentURL = currentURL.deletingLastPathComponent()
        }

        // Fallback: assume we're 3 levels deep (ARCAgentsDocs.swift -> ARCAgentsDocs -> Sources -> Root)
        return sourceFileURL
            .deletingLastPathComponent() // Remove ARCAgentsDocs.swift
            .deletingLastPathComponent() // Remove ARCAgentsDocs
            .deletingLastPathComponent() // Remove Sources
    }

    /// Returns all available documentation categories.
    ///
    /// Use this property to discover which categories of documentation are available
    /// in the package. Each category represents a major organizational section of
    /// the ARC Labs Studio documentation.
    ///
    /// ```swift
    /// let categories = ARCAgentsDocs.availableCategories
    /// for category in categories {
    ///     print("\(category.rawValue): \(category.description)")
    /// }
    /// ```
    public static var availableCategories: [DocumentCategory] {
        DocumentCategory.allCases
    }

    // MARK: Public Functions

    /// Returns the URL to a specific documentation file.
    ///
    /// - Parameter path: The relative path to the documentation file from the package root.
    ///                   For example: `"CLAUDE.md"` or `"Documentation/Architecture/clean-architecture.md"`
    ///
    /// - Returns: The URL to the requested documentation file.
    ///
    /// - Throws: ``DocumentationError/fileNotFound`` if the file doesn't exist.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Get main entry point
    /// let claudeURL = try ARCAgentsDocs.documentURL(for: "CLAUDE.md")
    ///
    /// // Get specific architecture document
    /// let mvvmURL = try ARCAgentsDocs.documentURL(for: "Documentation/Architecture/mvvm-c.md")
    /// ```
    public static func documentURL(for path: String) throws -> URL {
        let url = packageRootURL.appendingPathComponent(path)

        // Verify the file exists
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw DocumentationError.fileNotFound(path: path)
        }

        return url
    }

    /// Loads and returns the content of a documentation file as a string.
    ///
    /// This is the primary method for AI agents to load contextual documentation
    /// during development. It reads the file content and returns it as UTF-8 encoded text.
    ///
    /// - Parameter path: The relative path to the documentation file from the package root.
    ///                   For example: `"CLAUDE.md"` or `"Documentation/Quality/testing.md"`
    ///
    /// - Returns: The content of the documentation file as a string.
    ///
    /// - Throws: ``DocumentationError/fileNotFound`` if the file doesn't exist,
    ///           or ``DocumentationError/invalidEncoding`` if the file can't be decoded as UTF-8.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Load architecture guidelines for Clean Architecture
    /// let cleanArchDoc = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Architecture/clean-architecture.md")
    ///
    /// // Load testing standards
    /// let testingDoc = try ARCAgentsDocs.loadDocumentation(at: "Documentation/Quality/testing.md")
    /// ```
    public static func loadDocumentation(at path: String) throws -> String {
        let url = try documentURL(for: path)

        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            throw DocumentationError.invalidEncoding(path: path)
        }

        return content
    }

    /// Returns a list of all available documentation files in a specific category.
    ///
    /// - Parameter category: The documentation category to list files from.
    ///
    /// - Returns: An array of file names (without paths) in the specified category.
    ///
    /// - Throws: ``DocumentationError/categoryNotFound`` if the category directory doesn't exist.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // List all architecture documents
    /// let archDocs = try ARCAgentsDocs.listDocuments(in: .architecture)
    /// // Returns: ["clean-architecture.md", "mvvm-c.md", "protocol-oriented.md", "solid-principles.md"]
    /// ```
    public static func listDocuments(in category: DocumentCategory) throws -> [String] {
        let categoryPath = "Documentation/\(category.rawValue)"
        let categoryURL = packageRootURL.appendingPathComponent(categoryPath)

        guard FileManager.default.fileExists(atPath: categoryURL.path) else {
            throw DocumentationError.categoryNotFound(category: category.rawValue)
        }

        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(
            at: categoryURL,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )

        return contents
            .filter { $0.pathExtension == "md" }
            .map { $0.lastPathComponent }
            .sorted()
    }
}

// MARK: - Documentation Error

/// Errors that can occur when accessing documentation.
@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public enum DocumentationError: Error, Sendable {
    /// The requested documentation file was not found.
    case fileNotFound(path: String)

    /// The documentation file exists but couldn't be decoded as UTF-8.
    case invalidEncoding(path: String)

    /// The requested documentation category doesn't exist.
    case categoryNotFound(category: String)
}

// MARK: - DocumentationError + LocalizedError

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension DocumentationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "Documentation file not found at path: \(path)"
        case .invalidEncoding(let path):
            return "Documentation file at path '\(path)' could not be decoded as UTF-8"
        case .categoryNotFound(let category):
            return "Documentation category '\(category)' not found"
        }
    }
}
