
import SwiftUI

struct ParameterSection: View {
    
    var header: String
    var info: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .fontWeight(.semibold)
            Text(info)
                .foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}
