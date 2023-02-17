#!/bin/bash

#echo "Hi! Welcome! Here is Tic Tac Toe."

go_first=
player_o="o"
player_x="x"
moves=( 1 2 3 4 5 6 7 8 9 )
game_on=true
current=
game_result=
x_win=0
o_win=0
draw=0

generate_chessboard() {
    clear
    echo "Tic Tac Toe"
    echo "==========="
    echo " ${moves[0]} | ${moves[1]} | ${moves[2]} "
    echo "-----------"
    echo " ${moves[3]} | ${moves[4]} | ${moves[5]} "
    echo "-----------"
    echo " ${moves[6]} | ${moves[7]} | ${moves[8]} "
    echo "==========="
    return
}

current_player() {
    if (( (current % 2) == 0 )); then
        echo "Player 'x':"
        play=$player_x
    else
        echo "Player 'o':"
        play=$player_o
    fi
    return
}

player_action() {
    #echo "player action"
    read action 
    while [[ ! $action =~ ^[1-9]?$ ]] || [[ $action == "" ]]; do
        echo "Wrong! Input integer from 1 to 9" 
        #read action
        read action
    done
    space=${moves[$action - 1]}
    if [[ ! $space =~ ^[1-9]?$ ]]; then
        echo "Wrong! The position was occupied."
        player_action
    else
        moves[$action - 1]=$play
        ((current=current + 1))
    fi
    return
}


check_match() {
    if [[ ${moves[$1]} == ${moves[$2]} ]] && [[ ${moves[$2]} == ${moves[$3]} ]];then
        game_on=false
        if [[ ${moves[$1]} == "o" ]];then
            game_result="Player 'o' win the game!"
            echo "$game_result"
            ((o_win=o_win+1))
        else
            game_result="Player 'x' win the game!"
            echo "$game_result"
            ((x_win=x_win+1))
        fi
    fi
    return
}

winner() {
    check_match 0 1 2
    check_match 3 4 5 
    check_match 6 7 8
    check_match 0 3 6
    check_match 1 4 7
    check_match 2 5 8
    check_match 0 4 8
    check_match 2 4 6

    if (( (go_first % 2) == 0 )); then
        if [[ $game_result == "" ]] && (( $current == 9 )); then
            game_on=false
            echo "Draw!"
            ((draw=draw+1)) 
        fi
    else
        if [[ $game_result == "" ]] && (( ($current - 1) == 9 )); then
            game_on=false
            echo "Draw!"
            ((draw=draw+1)) 
        fi
    fi
    
    return
}

tic_tac_toe() {
    current=$1
    generate_chessboard
    while $game_on; do
        current_player
        player_action
        generate_chessboard
        winner
    done
    return
}

scoreboard() {
    echo "o win: $1" 
    echo "x win: $2"
    echo "draw: $3"
}

reset() {
    moves=( 1 2 3 4 5 6 7 8 9 ) 
    game_on=true
    game_result=
    current=
    go_first=
    sleep 2
    generate_chessboard
}

main() {
    
    while true; do
        read -p "Welcome Tic Tac Toe, 'y' to continue, 'n' to quit: "
        case $REPLY in
        'y')   
            while true; do
                read -p "First player(Input 'x' or 'o', 'q' to quit): " first_player
                case $first_player in
                    'x') 
                        go_first=0
                        break
                        ;;
                    'o')
                        go_first=1
                        break
                        ;;
                    'q')
                        echo "See you next time!"
                        exit
                        ;;
                    *)
                        echo "Wrong, Input 'x', 'o' or 'q'." >&2
                        continue
                        ;;
                esac
            done

            tic_tac_toe $go_first
            reset 

            scoreboard $o_win $x_win $draw
            ;;
        'n') 
            echo "See you next time!"
            break
            ;;
        *)
            echo "Wrong, Input 'y' or 'n'." >&2
            continue
        esac
    done
    
    return

}

# Here is my first program: Tic Tac Toe
# Enjoy yourself!
main
