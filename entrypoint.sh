#!/bin/bash -e

downloadArgs=()
[ "$INPUT_DEBUG" != true ] && downloadArgs+=(-q)

wget "https://github.com/JakeWharton/diffuse/releases/download/$INPUT_VERSION/diffuse-$INPUT_VERSION-binary.jar" "${downloadArgs[@]}" -O diffuse.jar

args=()
if [[ $INPUT_NEW_FILE == *.aab ]]; then
  args+=(--aab)
elif [[ $INPUT_NEW_FILE == *.aar ]]; then
  args+=(--aar)
elif [[ $INPUT_NEW_FILE == *.jar ]]; then
  args+=(--jar)
fi

if [ "${INPUT_DEBUG}" == true ]; then
  echo "Old: $(wc -c "$INPUT_OLD_FILE")"
  echo "New: $(wc -c "$INPUT_NEW_FILE")"
  echo "${args[@]}"
fi

diff=$(java -jar diffuse.jar diff "${args[@]}" "$INPUT_OLD_FILE" "$INPUT_NEW_FILE")
if [ "${INPUT_DEBUG}" == true ]; then
  echo "Step 1: ${#diff}"
fi
diff="${diff//'%'/'%25'}"
if [ "${INPUT_DEBUG}" == true ]; then
  echo "Step 2: ${#diff}"
fi
diff="${diff//$'\n'/'%0A'}"
if [ "${INPUT_DEBUG}" == true ]; then
  echo "Step 3: ${#diff}"
fi
diff="${diff//$'\r'/'%0D'}"

if [ "${INPUT_DEBUG}" == true ]; then
  echo "Diff size ${#diff}"
  echo "Diff $diff"
fi
echo "::set-output name=text-diff::$diff"
