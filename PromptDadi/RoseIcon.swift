import SwiftUI

struct RoseIcon: View {
    var body: some View {
        ZStack {
            // Near-black background
            Rectangle()
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                .frame(width: 512, height: 512)
            
            // Rose emoji
            Text("🌹")
                .font(.system(size: 256))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    RoseIcon()
        .frame(width: 512, height: 512)
} 