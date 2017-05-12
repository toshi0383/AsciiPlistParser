.PHONY = start-daemons
SOURCERY = ./.build/debug/sourcery

bootstrap:
	SWIFTPM_DEVELOPMENT=YES swift build
	swift package generate-xcodeproj
	# todo: Add fixtures to xcodeproj
start-daemons:
	$(SOURCERY) --templates Resources/SourceryTemplates/AutoEquatables.stencil --sources Sources/AsciiPlistParser/ --output Sources/AsciiPlistParser/Sourcery.out.swift
	$(SOURCERY) --templates Resources/SourceryTemplates/LinuxMain.stencil --sources Tests/AsciiPlistParserTests/ --output Tests/LinuxMain.swift --watch
