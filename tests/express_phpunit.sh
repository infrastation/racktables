#!/bin/sh

THISDIR=$(dirname "$0")
: "${PHPUNIT_BIN:=phpunit}"

command -v php >/dev/null || {
	echo 'ERROR: PHP CLI binary is not available!' >&2
	exit 3
}
if ! command -v "$PHPUNIT_BIN" >/dev/null; then
	echo "ERROR: $PHPUNIT_BIN is not an executable file" >&2
	exit 4
fi

case $("$PHPUNIT_BIN" --version) in
	'PHPUnit 7.'*|'PHPUnit 8.'*|'PHPUnit 9.'*)
		BOOTSTRAP_FILE=bootstrap_v7v8v9.php
		;;
	*)
		echo 'ERROR: unsupported PHPUnit version' >&2
		"$PHPUNIT_BIN" --version >&2
		exit 5
esac

# At this point it makes sense to test specific functions.
echo "Running PHPUnit tests using bootstrap file '$BOOTSTRAP_FILE'."

cd "$THISDIR" || exit 1
"$PHPUNIT_BIN" --group small --bootstrap $BOOTSTRAP_FILE || exit 1
