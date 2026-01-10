#!/usr/bin/env bash

TODO_FILE="TODO.md"

command="$1"
shift

if [[ "$command" != "init" && "$command" != "help" && ! -f "$TODO_FILE" ]]; then
    echo "Error: $TODO_FILE not found."
    echo "To create it run:
    $ todos.sh init"
    exit 1
fi


case "$command" in
    help)
      echo "Usage: $0 [command] [args]"
      echo ""
      echo "Commands:"
      echo "  list, ls          List all todos (default)"
      echo "  add, + [text]     Add a new todo"
      echo "  done, d [text]    Mark a todo as done"
      echo "  wip, p [text]     Mark a todo as in-progress"
      echo "  rm, - [text]      Remove a todo"
      echo "  init              Initialize a new todo list"
      echo "  help              Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 add \"Code a new feature\""
      echo "  $0 done \"Code a new feature\""
      echo "  $0 init"
        ;;
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
    init)
        if [[ -f "$TODO_FILE" ]]; then
            echo "Error: $TODO_FILE already exists."
        else
            echo "<!-- Todo list generated and controlled by todos.sh
For more information run:
$ ./todos.sh help
-->" > "$TODO_FILE"
            echo "Initialized $TODO_FILE"
        fi
        ;;
    list|ls|*)
        echo "Todos:"
        echo "--------------------------------"
        in_comment=false
        while IFS= read -r line; do
            # Remove leading/trailing whitespace
            line=$(echo "$line" | xargs)

            if [[ "$line" =~ ^\<\!-- ]]; then
                if [[ ! "$line" =~ --\>$ ]]; then
                    in_comment=true
                fi
                continue
            fi

            if [[ "$in_comment" == true ]]; then
                if [[ "$line" =~ --\>$ ]]; then
                    in_comment=false
                fi
                continue
            fi

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
