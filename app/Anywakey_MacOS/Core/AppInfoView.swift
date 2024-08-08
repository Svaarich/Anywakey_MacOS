
import SwiftUI

struct AppInfoView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Binding var showView: Bool
    @State private var hoverClose: Bool = false
    @State private var showFileImporter: Bool = false
    
    private let linkTreeURL = "https://linktr.ee/svarychevskyi"
    private let gitHubURL = "https://github.com/Svaarich"
    private let gitHubRepoURL = "https://github.com/Svaarich/LANWakeUp-IOS"
    private let bugReportURL = "https://github.com/Svaarich/LANWakeUp-IOS/issues/new"
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Anywakey")
                    .fontWeight(.semibold)
                    .padding(.leading, 8)
                
                VStack(spacing: 0) {
                    
                    githubButton
                    
                    divider
                    
                    repoButton
                    
                    divider
                    
                    linktreeButton
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                VStack(spacing: 0) {
                    
                    bugButton
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                VStack(spacing: 0) {
                    
                    importButton
                    
                    divider
                    
                    shareButton
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .buttonStyle(.plain)
            .padding(8)
            
            Spacer()
            
            HStack {
                dismissButton
                Spacer()
            }
        }
        
        .padding(8)
        .frame(width: 200)
        
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.text]) { result in
            do {
                let fileUrl = try result.get()
                if fileUrl.startAccessingSecurityScopedResource() {
                    dataService.importConfig(from: fileUrl)
                    showView = false
                    print("success")
                }
                fileUrl.stopAccessingSecurityScopedResource()
            } catch {
                print("Error file reading. \(error)")
            }
        }
    }
}

extension AppInfoView {
    
    
    // MARK: PROPERTIES
    
    private var divider: some View {
        Divider()
            .foregroundColor(.white)
    }
    
    // github page
    private var githubButton: some View {
        Link(destination: URL(string: gitHubURL)!) {
            HStack {
                Image("gitLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                Text("GitHub")
            }
            .buttonify()
        }
    }
    
    // repo page
    private var repoButton: some View {
        Link(destination: URL(string: gitHubRepoURL)!) {
            HStack {
                Image(systemName: "text.book.closed.fill")
                Text("Application sources")
            }
            .buttonify()
        }
    }
    
    private var linktreeButton: some View {
        Link(destination: URL(string: linkTreeURL)!) {
            HStack {
                Image(systemName: "tree.circle")
//                    .offset(x: -2)
                Text("Linktree")
//                    .offset(x: -4)
                
            }
            .buttonify()
        }
    }
    
    // bug report button
    private var bugButton: some View {
        Link(destination: URL(string: bugReportURL)!) {
            HStack {
                Image(systemName: "ant.fill")
                Text("Issue / Bug report")
            }
            .buttonify()
        }
    }
    
    private var importButton: some View {
        Button {
            showFileImporter = true
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.down.fill")
                Text("Import config")
            }
            .buttonify()
        }
    }
    
    private var shareButton: some View {
        Button {
            ShareManager.instance.saveConfig(config: dataService.getConfig())
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up.fill")
                Text("Export config")
            }
            .buttonify()
        }
    }
    

    // close button
    private var dismissButton: some View {
        BubbleButton {
            showView = false
        } label: {
            Image(systemName: "chevron.left")
        }
    }
}
