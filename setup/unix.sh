#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# Used by GitHub Actions & local setup
# Psych Engine 0.6.3 Mobile Port + hxCodec Overlay Support

echo "🔧 Setting up Haxe libraries..."
haxelib setup ~/haxelib

echo "📦 Installing core dependencies..."
haxelib install tjson 1.4.0 --quiet
haxelib install flixel 5.2.2 --quiet
haxelib install flixel-addons 2.11.0 --quiet
haxelib install flixel-ui 2.4.0 --quiet
haxelib install hscript 2.4.0 --quiet

echo "📜 Installing Lua and utility libs..."
haxelib git linc_luajit https://github.com/PsychExtendedThings/linc_luajit --quiet

echo "🎬 Installing hxcpp + lime..."
haxelib git hxcpp https://github.com/PsychExtendedThings/hxcpp --quiet
haxelib git lime https://github.com/PsychExtendedThings/lime-new --quiet
haxelib install openfl 9.2.2 --quiet

# ✅ Optimized hxCodec installation (polybiusproxy version)
# Only installs if missing, skips re-downloading in cached builds
haxelib remove hxCodec --quiet || true
rm -rf ~/haxelib/hxCodec || true
echo "🔹 Installing hxCodec (polybiusproxy)"
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git
