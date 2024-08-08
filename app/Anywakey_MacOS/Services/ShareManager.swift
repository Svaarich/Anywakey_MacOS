
import Foundation
import SwiftUI

public class ShareManager {
    
    private init() {}
    
    static let instance = ShareManager()
    
    // save
    public func saveConfig(config: String) {
        do {
            try config.write(to: showSavePanel()!, atomically: true, encoding: .utf8)
            print("String saved successfully")
        } catch {
            print("Error saving string: \(error)")
        }
    }
    
    // show save panel
    private func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.text]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
    
        savePanel.title = "Save your configuration"
        savePanel.message = "Choose a folder and a name to store the config."
        savePanel.nameFieldLabel = "Config file name:"
        
        savePanel.nameFieldStringValue = "anywakey_config.txt"
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
}

