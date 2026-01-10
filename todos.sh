#!/usr/bin/env bash

TODO_FILE="TODO.md"

if [[ ! -f "$TODO_FILE" ]]; then
    echo "Error: $TODO_FILE not found."
    exit 1
fi

command="$1"
shift

case "$command" in
    add|+)
        echo "[] $*" >> "$TODO_FILE"
        echo "Added: $*"
        ;;
    done|finish|d)
        search_term="$*"
        if grep -q "\[] .*$search_term" "$TODO_FILE"; then
            sed -i "/\[] .*$search_term/s/\[]/[x]/" "$TODO_FILE"
            echo "Marked as done: $search_term"
        else
            echo "Todo not found or already done: $search_term"
        fi
        ;;
    wip|doing|p|partial)
        search_term="$*"
        # Match any status: [], [x], or [-] (using [x-]* to match empty or x or -)
        if grep -q "\[[x-]*\] .*$search_term" "$TODO_FILE"; then
            sed -i "/\[[x-]*\] .*$search_term/s/\[[x-]*\]/[-]/" "$TODO_FILE"
            echo "Marked as in-progress: $search_term"
        else
            echo "Todo not found: $search_term"
        fi
        ;;
    rm|delete|-)
        search_term="$*"
        if grep -q ".*$search_term" "$TODO_FILE"; then
            sed -i "/.*$search_term/d" "$TODO_FILE"
            echo "Removed: $search_term"
        else
            echo "Todo not found: $search_term"
        fi
        ;;
    list|ls|*)
        echo "Todos:"
        echo "--------------------------------"
        while IFS= read -r line; do
            # Remove leading/trailing whitespace
            line=$(echo "$line" | xargs)
            if [[ "$line" =~ ^\[x\](.*) ]]; then
                content="${BASH_REMATCH[1]}"
                printf "\033[32m✔ %s\033[0m\n" "$content"
            elif [[ "$line" =~ ^\[\-\](.*) ]]; then
                content="${BASH_REMATCH[1]}"
                printf "\033[33m◐ %s\033[0m\n" "$content"
            elif [[ "$line" =~ ^\[\](.*) ]]; then
                content="${BASH_REMATCH[1]}"
                printf "\033[1m☐ %s\033[0m\n" "$content"
            elif [[ -n "$line" ]]; then
                 printf "\033[34m%s\033[0m\n" "$line"
            fi

        done < "$TODO_FILE"
        ;;
esac
