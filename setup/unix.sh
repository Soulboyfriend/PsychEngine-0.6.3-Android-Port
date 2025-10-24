#!/bin/sh
# SETUP FOR MAC, LINUX, AND GITHUB WORKFLOWS
# Make sure Haxe is installed before running this script.

cd ..
echo "🔧 Setting up haxelib repository..."
haxelib setup ~/haxelib

echo "📦 Installing dependencies..."
echo "This might take a few moments depending on your internet speed."

# Core dependencies
haxelib git linc_luajit https://github.com/PsychExtendedThings/linc_luajit --quiet
haxelib install tjson --quiet
haxelib install flixel 5.2.2 --quiet
haxelib install flixel-addons 2.11.0 --quiet
haxelib install flixel-ui 2.4.0 --quiet
haxelib install hscript 2.4.0 --quiet

# =============================================
# 🚀 FIXED: Safe hxCodec install (polybiusproxy version)
# =============================================

echo "🔹 Installing latest hxCodec (fast shallow clone)..."

# Remove old version safely
haxelib remove hxCodec || true

# Shallow clone to avoid timeouts in GitHub Actions
git clone --depth=1 https://github.com/polybiusproxy/hxCodec hxCodec-lib

# Link hxCodec locally (faster and CI-safe)
haxelib dev hxCodec hxCodec-lib

# =============================================

# Remaining libraries
haxelib git hxcpp https://github.com/PsychExtendedThings/hxcpp --quiet
haxelib git lime https://github.com/PsychExtendedThings/lime-new --quiet
haxelib install openfl 9.2.2 --quiet

echo "✅ Setup complete! All dependencies installed."
