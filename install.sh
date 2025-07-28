#!/bin/bash

echo "🚀 Installing Prompt Dadi..."

# Check if Command Line Tools are installed
if ! command -v swift &> /dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⚠️  Please complete the installation and run this script again."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Please run this script from the prompt-dadi directory"
    exit 1
fi

# Build the app
echo "🔨 Building Prompt Dadi..."
swift build -c release

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi

# Create app bundle
echo "📦 Creating app bundle..."
mkdir -p PromptDadi.app/Contents/MacOS
mkdir -p PromptDadi.app/Contents/Resources

# Copy executable
cp .build/release/PromptDadi PromptDadi.app/Contents/MacOS/

# Create Info.plist
cat > PromptDadi.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>PromptDadi</string>
    <key>CFBundleIconFile</key>
    <string>icon.icns</string>
    <key>CFBundleIdentifier</key>
    <string>com.promptdadi.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>PromptDadi</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <false/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
EOF

# Generate icon
echo "🎨 Generating app icon..."
cat > generate_icon.swift << 'EOF'
import SwiftUI
import AppKit

let iconSize: CGFloat = 512
let image = NSImage(size: NSSize(width: iconSize, height: iconSize))

image.lockFocus()

// Near-black background
NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).setFill()
NSRect(x: 0, y: 0, width: iconSize, height: iconSize).fill()

// Rose emoji
let roseText = "🌹"
let font = NSFont.systemFont(ofSize: iconSize * 0.6)
let attributes: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor.white
]

let textSize = roseText.size(withAttributes: attributes)
let textRect = NSRect(
    x: (iconSize - textSize.width) / 2,
    y: (iconSize - textSize.height) / 2,
    width: textSize.width,
    height: textSize.height
)

roseText.draw(in: textRect, withAttributes: attributes)

image.unlockFocus()

if let tiffData = image.tiffRepresentation,
   let bitmap = NSBitmapImageRep(data: tiffData),
   let pngData = bitmap.representation(using: .png, properties: [:]) {
    
    let iconPath = "PromptDadi.app/Contents/Resources/icon.png"
    try? pngData.write(to: URL(fileURLWithPath: iconPath))
    print("✅ Rose icon saved to: \(iconPath)")
}
EOF

swift generate_icon.swift

# Create ICNS
echo "🖼️  Creating app icon..."
mkdir -p PromptDadi.app/Contents/Resources/icon.iconset
sips -z 16 16 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_16x16.png
sips -z 32 32 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_16x16@2x.png
sips -z 32 32 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_32x32.png
sips -z 64 64 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_32x32@2x.png
sips -z 128 128 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_128x128.png
sips -z 256 256 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_128x128@2x.png
sips -z 256 256 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_256x256.png
sips -z 512 512 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_256x256@2x.png
sips -z 512 512 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_512x512.png
sips -z 1024 1024 PromptDadi.app/Contents/Resources/icon.png --out PromptDadi.app/Contents/Resources/icon.iconset/icon_512x512@2x.png

iconutil -c icns PromptDadi.app/Contents/Resources/icon.iconset -o PromptDadi.app/Contents/Resources/icon.icns

# Clean up
rm -rf PromptDadi.app/Contents/Resources/icon.iconset
rm generate_icon.swift

# Set permissions
chmod +x PromptDadi.app/Contents/MacOS/PromptDadi

echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 You can now:"
echo "   1. Run directly: open PromptDadi.app"
echo "   2. Install to Applications: cp -r PromptDadi.app /Applications/"
echo ""
echo "📋 Keyboard Shortcuts:"
echo "   • Cmd+N: Create new prompt"
echo "   • Cmd+Shift+N: Create new folder"
echo "   • Cmd+E: Edit selected prompt"
echo "   • Cmd+Shift+P: Command palette"
echo "   • ?: Show help"
echo ""
echo "🌹 Enjoy Prompt Dadi!" 