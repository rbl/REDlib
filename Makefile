
PROJ=REDlib.xcodeproj
LIB=libREDlib.a
DIST=./dist

all: fat

fat: arm arm64 i386 x86_64
	rm -rf ${DIST} 2>&1 >/dev/null
	mkdir -p ${DIST}
	lipo -create './build-arm/${LIB}' './build-arm64/${LIB}' './build-i386/${LIB}' './build-x86_64/${LIB}' -output '${DIST}/${LIB}'
	cp -a ./build-arm/usr ${DIST}

arm:
	xcodebuild -project ${PROJ} -configuration 'Release' -sdk 'iphoneos7.0' clean build ARCHS='armv7 armv7s' IPHONEOS_DEPLOYMENT_TARGET='5.0' TARGET_BUILD_DIR='./build-arm' BUILT_PRODUCTS_DIR='./build-arm'

arm64:
	xcodebuild -project ${PROJ} -configuration 'Release' -sdk 'iphoneos7.0' clean build ARCHS='arm64' IPHONEOS_DEPLOYMENT_TARGET='7.0' TARGET_BUILD_DIR='./build-arm64' BUILT_PRODUCTS_DIR='./build-arm64'

i386:
	xcodebuild -project ${PROJ} -configuration 'Release' -sdk 'iphonesimulator7.0' clean build ARCHS='i386' IPHONEOS_DEPLOYMENT_TARGET='5.0' TARGET_BUILD_DIR='./build-i386' BUILT_PRODUCTS_DIR='./build-i386'

x86_64:
	xcodebuild -project ${PROJ} -configuration 'Release' -sdk 'iphonesimulator7.0' clean build ARCHS='x86_64' IPHONEOS_DEPLOYMENT_TARGET='5.0' TARGET_BUILD_DIR='./build-x86_64' BUILT_PRODUCTS_DIR='./build-x86_64'
