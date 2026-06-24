#!/usr/bin/bash

# FIND ALL .gitignore AND ADDS CONTENT TO ROOT .gitignore
# FOR CONVERT MULTIPLE TO MONOREPO
# MUST BE EXECUTED IN ROOT DIRECTORY

# Define the root .gitignore file
ROOT_GITIGNORE=".gitignore"

# Create the root .gitignore if it doesn't exist
touch "$ROOT_GITIGNORE"

echo ">>> Searching for nested .gitignore files..."

# Find all .gitignore files, excluding the root one
find . -name ".gitignore" -not -path "./$ROOT_GITIGNORE" | while read -r nested_ignore; do
    # Get the directory path relative to the root (e.g., ./src/components -> src/components)
    dir_path=$(dirname "$nested_ignore")
    dir_path="${dir_path#./}"
    
    echo "Processing: $nested_ignore"
    echo -e "\n# Rules from $nested_ignore" >> "$ROOT_GITIGNORE"

    # Read each line in the nested .gitignore
    while IFS= read -r line || [ -n "$line" ]; do
        # Ignore empty lines and comments (lines starting with '#')
        trimmed_line=$(echo "$line" | xargs)
        if [[ -z "$trimmed_line" || "$trimmed_line" =~ ^# ]]; then
            continue
        fi

        # Prefix with appropriate directory, ensuring correct path formatting
        if [[ "$trimmed_line" == /* ]]; then
            # Absolute pattern relative to the subdirectory
            echo "$dir_path${trimmed_line#/}" >> "$ROOT_GITIGNORE"
        else
            # Relative pattern
            echo "$dir_path/$trimmed_line" >> "$ROOT_GITIGNORE"
        fi
    done < "$nested_ignore"
done

echo ">>> Successfully consolidated all rules into $ROOT_GITIGNORE"

