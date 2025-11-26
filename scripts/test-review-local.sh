#!/bin/bash
# Test code review prompt locally (requires cursor CLI and gh CLI)
# Usage: ./scripts/test-review-local.sh <pr-number>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <pr-number>"
    echo "Example: $0 3"
    exit 1
fi

PR_NUMBER=$1
PROMPT_FILE=".github/workflows/prompts/embedded-systems-review.txt"

# Check if prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "❌ Error: Prompt file not found: $PROMPT_FILE"
    exit 1
fi

# Check if cursor-agent is available
if ! command -v cursor-agent >/dev/null 2>&1; then
    echo "❌ Error: cursor-agent not found"
    echo "Install it with: curl https://cursor.com/install | bash"
    exit 1
fi

# Check if gh CLI is available
if ! command -v gh >/dev/null 2>&1; then
    echo "❌ Error: gh CLI not found"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

echo "📋 Testing code review prompt locally"
echo "PR Number: $PR_NUMBER"
echo "Prompt file: $PROMPT_FILE"
echo ""

# Get PR info
echo "Fetching PR information..."
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
PR_INFO=$(gh pr view $PR_NUMBER --json number,headRefOid,baseRefOid,title)

PR_HEAD_SHA=$(echo "$PR_INFO" | jq -r '.headRefOid')
PR_BASE_SHA=$(echo "$PR_INFO" | jq -r '.baseRefOid')
PR_TITLE=$(echo "$PR_INFO" | jq -r '.title')

echo "Repository: $REPO"
echo "PR Title: $PR_TITLE"
echo "Head SHA: $PR_HEAD_SHA"
echo "Base SHA: $PR_BASE_SHA"
echo ""

# Prepare prompt with actual values
echo "Preparing prompt..."
TEMP_PROMPT=$(mktemp)
sed -e "s|{{REPO}}|$REPO|g" \
    -e "s|{{PR_NUMBER}}|$PR_NUMBER|g" \
    -e "s|{{PR_HEAD_SHA}}|$PR_HEAD_SHA|g" \
    -e "s|{{PR_BASE_SHA}}|$PR_BASE_SHA|g" \
    -e "s|{{BLOCKING_REVIEW}}|false|g" \
    -e "s|{{REVIEW_DETAIL_LEVEL}}|detailed|g" \
    -e "s|{{REVIEW_MAX_COMMENTS}}|20|g" \
    -e "s|{{MODEL}}|sonnet-4.5|g" \
    "$PROMPT_FILE" > "$TEMP_PROMPT"

echo "✅ Prompt prepared"
echo ""
echo "Prompt preview (first 500 chars):"
head -c 500 "$TEMP_PROMPT"
echo "..."
echo ""

# Check if CURSOR_API_KEY is set
if [ -z "$CURSOR_API_KEY" ]; then
    echo "⚠️  Warning: CURSOR_API_KEY environment variable not set"
    echo "Set it with: export CURSOR_API_KEY=your_key"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Run cursor-agent
echo "🚀 Running cursor-agent..."
echo ""
cursor-agent --force --model "sonnet-4.5" --output-format=text --print "$(cat $TEMP_PROMPT)"

# Cleanup
rm -f "$TEMP_PROMPT"
echo ""
echo "✅ Test completed"

