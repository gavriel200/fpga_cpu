array of 52 cards 8 bit

[taken 1 bit] [suit 2 bits] [card value 5 bits ]

taken:
0 not taken, 1 taken

suit:
0 hearts, 1 spades, 2 dimonds, 3 clubs

cards:
1 ace
2 - 10
11 jack
12 queen
13 king

params needed:

state
array of all cards - 52 * (uint8)
array of player cards - len N (uint8) + cards N * (uint8)
array of dealer cards - len N (uint8) + cards N * (uint8)
player count - uint8
dealer count - uint8



states:
- init:
    init array of cards:
    create all the cards with taken = 0

    clean screen
    loop and clean screen
    
    deal the dealer 2 cards 
    deal the player 2 cards
    use random to choose from the array if already taken keep going

    draw the cards
    using the len of each hand and the index of the card draw more to the side

    quick check if player has 21 if so go to win
    else go to choose 

- player choose to ether stay or hit
    wait for button press

    if stay go to dealer turn
    else go to hit

- hit
    add another card and draw it

    check if player has 21 go to win
    check if player has more then 21 go to lost
    else go back to player choose to ether stay or hit

- dealer turn
    if dealer has more then 21 go to win
    if dealer has more then player go to lose
    else check if dealer has less then 17

- dealer hit
    add card to dealer and draw it
    go to dealer turn

- player win
    check if dealer has 21 go to draw

    draw player wins


- player lose
    draw player lost :(

- draw
    draw no one wins




