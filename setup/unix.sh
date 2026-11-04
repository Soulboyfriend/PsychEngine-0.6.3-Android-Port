#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download
cd ..
echo Makking the main haxelib and setuping folder in same time..
haxelib setup ~/haxelib
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib git linc_luajit https://github.com/PsychExtendedThings/linc_luajit --quiet
haxelib install tjson --quiet
haxelib install flixel 5.2.2 --quiet
haxelib install flixel-addons 2.11.0 --quiet
haxelib install flixel-ui 2.4.0 --quiet
haxelib install hscript 2.4.0 --quiet
haxelib git hxCodec https://github.com/PsychExtendedThings/hxCodec-0.6.3 --quiet
haxelib git hxcpp https://github.com/PsychExtendedThings/hxcpp --quiet
haxelib git lime https://github.com/PsychExtendedThings/lime-new --quiet
haxelib install openfl 9.2.2 --quiet
OPENFL_STAGE="$HOME/haxelib/openfl/9,2,2/src/openfl/display/Stage.hx"

sed -i 's/__onLimeUpdate(deltaTime:Int)/__onLimeUpdate(deltaTime:Float)/' "$OPENFL_STAGE"
sed -i 's/__deltaTime = deltaTime;/__deltaTime = Std.int(deltaTime);/' "$OPENFL_STAGE"
echo Finished!
