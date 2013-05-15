TARGET = HelloBird
TEMPLATE = app
CONFIG -= console
CONFIG -= app_bundle
CONFIG -= qt core

# for the reason that the "debug" configs will declared after
# the project file ,my config "DESTDIR" does not works right
# if you want to compile a release version ,open the line under this line
#CONFIG -= debug

contains(CONFIG,debug) {
        DESTDIR = bin/debug/
} else {
        DESTDIR = bin/release/
}

RESOURCES = Resources.qrc


SOURCES += main.cpp  

HEADERS += main.h  

# set a variable for config cocos2dx modules
# --------------------------------------------
# the simple audio engine
COCOS2D-X_MODULES += CocosDenshion
# some extensions eg: CCTableView
COCOS2D-X_MODULES += extensions
# the box2d physics engine
COCOS2D-X_MODULES += box2d
# the chipmunk physics engine
COCOS2D-X_MODULES += chipmunk
# --------------------------------------------

COCOS2D_ROOT = $$system(echo $COCOS2D_ROOT)

# set include path and depend path
COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/cocos2dx \
	$$COCOS2D_ROOT/cocos2dx/include \
	$$COCOS2D_ROOT/cocos2dx/cocoa \
	$$COCOS2D_ROOT/cocos2dx/kazmath/include \
	$$COCOS2D_ROOT/cocos2dx/platform

contains(COCOS2D-X_MODULES,CocosDenshion) {
	COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/CocosDenshion/include
}

contains(COCOS2D-X_MODULES,extensions) {
	COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/extensions
}

contains(COCOS2D-X_MODULES,box2d) {
	COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/external/
#	COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/external/Box2D
}

contains(COCOS2D-X_MODULES,chipmunk) {
	COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/external/chipmunk/include/chipmunk
}

#set the platform depended include and depend path
unix:!macx {
	DEFINES += LINUX

	COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/cocos2dx/platform/linux \
		$$COCOS2D_ROOT/cocos2dx//platform/third_party/linux/glew-1.7.0/glew-1.7.0/include/ \
		$$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/libfreetype2 \
		$$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/libxml2 \
		$$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/libjpeg
		
	LBITS = $$system(getconf LONG_BIT)

        contains(LBITS,64) {
		COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/platform/third_party/linux/include64
		STATICLIBS_DIR += $$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/libraries/lib64
		contains(COCOS2D-X_MODULES,CocosDenshion) {
			SHAREDLIBS_DIR += $$COCOS2D_ROOT/CocosDenshion/third_party/fmod/lib64/api/lib
			SHAREDLIBS += -L$$SHAREDLIBS_DIR -lfmodex64
		}

	} else {
		COCOS_INCLUDE_DEPEND_PATH += $$COCOS2D_ROOT/platform/third_party/linux
		STATICLIBS_DIR += $$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/libraries
		contains(COCOS2D-X_MODULES,CocosDenshion) {
			SHAREDLIBS_DIR += $$COCOS2D_ROOT/CocosDenshion/third_party/fmod/api/lib
			SHAREDLIBS += -L$$SHAREDLIBS_DIR -lfmodex
		}
	}

	STATICLIBS += $$STATICLIBS_DIR/libfreetype.a \
		$$STATICLIBS_DIR/libxml2.a \
		$$STATICLIBS_DIR/libpng.a \
		$$STATICLIBS_DIR/libjpeg.a \
		$$STATICLIBS_DIR/libtiff.a \
		$$STATICLIBS_DIR/libcurl.a

	contains(CONFIG,debug) {
		DEFINES += DEBUG

		SHAREDLIBS += -L$$COCOS2D_ROOT/lib/linux/Debug -Wl,-rpath,$$COCOS2D_ROOT/lib/linux/Debug
	
		contains(COCOS2D-X_MODULES,box2d) {
			STATICLIBS += $$COCOS2D_ROOT/lib/linux/Debug/libbox2d.a
		}
		contains(COCOS2D-X_MODULES,chipmunk) {
			STATICLIBS += $$COCOS2D_ROOT/lib/linux/Debug/libchipmunk.a
		}
	} else {
		DEFINES += NDEBUG

		SHAREDLIBS += -L$$COCOS2D_ROOT/lib/linux/Release -Wl,-rpath,$$COCOS2D_ROOT/lib/linux/Release

		contains(COCOS2D-X_MODULES,box2d) {
			STATICLIBS += $$COCOS2D_ROOT/lib/linux/Release/libbox2d.a
		}
		contains(COCOS2D-X_MODULES,chipmunk) {
			STATICLIBS += $$COCOS2D_ROOT/lib/linux/Release/libchipmunk.a
		}
	}

	SHAREDLIBS += -lcocos2d -lrt -lz
	contains(COCOS2D-X_MODULES,CocosDenshion) {
		SHAREDLIBS += -lcocosdenshion
	}

	SHAREDLIBS += -lglfw -lGL
	SHAREDLIBS += -Wl,-rpath,$${SHAREDLIBS_DIR}
	SHAREDLIBS += -L$$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/glew-1.7.0/glew-1.7.0/lib -lGLEW
	SHAREDLIBS += -Wl,-rpath,$$COCOS2D_ROOT/cocos2dx/platform/third_party/linux/glew-1.7.0/glew-1.7.0/lib

	SHAREDLIBS += -Wl,-rpath,$$STATICLIBS_DIR

	# if need curl , open this
	SHAREDLIBS += -lcurl
	
	LIBS +=	$${STATICLIBS}
	LIBS += $${SHAREDLIBS}
} 
	
INCLUDEPATH += $${COCOS_INCLUDE_DEPEND_PATH}
DEPENDPATH += $${COCOS_INCLUDE_DEPEND_PATH}

include(Classes/AccelerometerTest.pri)
include(Classes/ZwoptexTest.pri)
include(Classes/UserDefaultTest.pri)
include(Classes/TransitionsTest.pri)
include(Classes/TouchesTest.pri)
include(Classes/TileMapTest.pri)
include(Classes/TextureCacheTest.pri)
include(Classes/Texture2dTest.pri)
include(Classes/TextInputTest.pri)
include(Classes/SpriteTest.pri)
include(Classes/ShaderTest.pri)
include(Classes/SchedulerTest.pri)
include(Classes/SceneTest.pri)
include(Classes/RotateWorldTest.pri)
include(Classes/RenderTextureTest.pri)
include(Classes/PerformanceTest.pri)
include(Classes/ParticleTest.pri)
include(Classes/ParallaxTest.pri)
include(Classes/NodeTest.pri)
include(Classes/MutiTouchTest.pri)
include(Classes/MotionStreakTest.pri)
include(Classes/MenuTest.pri)
include(Classes/LayerTest.pri)
include(Classes/LabelTest.pri)
include(Classes/KeypadTest.pri)
include(Classes/IntervalTest.pri)
include(Classes/FontTest.pri)
include(Classes/ExtensionsTest.pri)
include(Classes/EffectsTest.pri)
include(Classes/EffectsAdvancedTest.pri)
include(Classes/DrawPrimitivesTest.pri)
include(Classes/CurrentLanguageTest.pri)
include(Classes/CurlTest.pri)
include(Classes/CocosDenshionTest.pri)
include(Classes/ClickAndMoveTest.pri)
include(Classes/Classes.pri)
include(Classes/ChipmunkAccelTouchTest.pri)
include(Classes/BugsTest.pri)
include(Classes/Box2DTestBed.pri)
include(Classes/Box2DTest.pri)
include(Classes/ActionsTest.pri)
include(Classes/ActionsProgressTest.pri)
include(Classes/ActionsEaseTest.pri)
include(Classes/ActionManagerTest.pri)

