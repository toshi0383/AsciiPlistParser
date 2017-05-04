.PHONY = start-daemons

start-daemons:
	sourcery --templates Resources/SourceryTemplates/AutoEquatables.stencil --sources Sources/AsciiPlistParser/ --output Sources/AsciiPlistParser/Sourcery.out.swift
	sourcery --templates Resources/SourceryTemplates/LinuxMain.stencil --sources Tests/AsciiPlistParserTests/ --output Tests/LinuxMain.swift --watch
