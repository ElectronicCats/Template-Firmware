#!/bin/bash
# Validate that the prompt file has all required placeholders
# Usage: ./scripts/validate-prompt.sh

set -e

PROMPT_FILE=".github/workflows/prompts/embedded-systems-review.txt"

if [ ! -f "$PROMPT_FILE" ]; then
    echo "❌ Error: Prompt file not found: $PROMPT_FILE"
    exit 1
fi

echo "🔍 Validating prompt file: $PROMPT_FILE"
echo ""

# Check for required placeholders
REQUIRED_PLACEHOLDERS=(
    "{{REPO}}"
    "{{PR_NUMBER}}"
    "{{PR_HEAD_SHA}}"
    "{{PR_BASE_SHA}}"
    "{{BLOCKING_REVIEW}}"
    "{{REVIEW_DETAIL_LEVEL}}"
    "{{REVIEW_MAX_COMMENTS}}"
    "{{MODEL}}"
)

MISSING=0
for placeholder in "${REQUIRED_PLACEHOLDERS[@]}"; do
    if grep -q "$placeholder" "$PROMPT_FILE"; then
        echo "✅ Found: $placeholder"
    else
        echo "❌ Missing: $placeholder"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
if [ $MISSING -eq 0 ]; then
    echo "✅ All required placeholders are present"
    echo "✅ Prompt file is valid"
    exit 0
else
    echo "❌ $MISSING placeholder(s) missing"
    echo "❌ Prompt file validation failed"
    exit 1
fi

