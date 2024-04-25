# Ensure apksigner is installed and in your PATH
if ! command -v apksigner &> /dev/null
then
    echo "apksigner is not found. Please install it and ensure it's in your PATH."
    exit 1
fi

# Iterate through all .apk files in the current folder
for apk_file in downloads/*.apk; do
    # Run apksigner verify and capture the output and errors
    output=$(apksigner verify "$apk_file" 2>&1)

    # Check if the word "Malformed" is present in the output
    if [[ $output == *"Malformed APK"* ]]; then
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') VERIFICATION: [BAD] $apk_file is not passing the verification!"
        rm -f "$apk_file"
    else
        echo "$(date -u '+%Y-%m-%d %H:%M:%S') VERIFICATION: [GOOD] $apk_file is passing the verification!"
    fi
done