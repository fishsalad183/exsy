# Mark recipe-only targets as phony so make doesn't treat names of directories
# (e.g. the 'test' directory) as up-to-date files and skip recipes.
.PHONY: clean deps test build_apk build_web update_deps update_deps_major_versions update_flutter

clean:
	flutter clean

deps:
	flutter pub get

test:
	flutter test -j 1 --coverage

build_apk:
	@echo "Starting build. Make sure you've set the environment to the desired version (e.g. prod or dev)!"
	flutter build apk --split-per-abi --no-tree-shake-icons
	@echo "Build completed. Check README.md for more information."

build_web:
	@echo "Starting build. Make sure you've set the environment to the desired version (e.g. prod or dev)!"
	flutter build web
	@echo "Build completed. Check README.md for more information."

update_deps:
	flutter pub upgrade

update_deps_major_versions:
	flutter pub upgrade --major-versions

update_flutter:
	flutter upgrade