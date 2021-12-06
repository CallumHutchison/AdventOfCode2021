package Bingo;

public class Bingo {
    public static GetWinner(List<Integer> numbers, BingoBoard[] boards) {
        for(int num : numbers) {
            for(BingoBoard board : boards) {
                board.mark(num);
                if(board.hasWon()) {
                    return board;
                }
            }
        }
        return null;
    }
}