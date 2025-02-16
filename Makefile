clean:
	flutter clean

dependencies:
	flutter pub get

run_tests:
	flutter test -j 1 --coverage

build_apk:
	flutter build apk --split-per-abi --no-tree-shake-icons

build_web:
	flutter build web

update_dependencies:
	flutter pub upgrade

update_dependencies_major_versions:
	flutter pub upgrade --major-versions

update_flutter:
	flutter upgrade