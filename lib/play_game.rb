# - players choose color of their pieces (in BOARD)
# - a 'coinflip' method picks first player
# - LOOP
#   - player picks a column
#   - method finds the lowest unoccupied slot & 'drops' a disc there
#   - once a player has 4 or more discs in play, checks every new disc if it meets victory conditions
#     - finds whether the board includes 3  other discs in positions to complete a line, column, or diagonal of 4
#   - changes active player