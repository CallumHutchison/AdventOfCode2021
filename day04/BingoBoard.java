package Bingo;
import java.util.HashSet;

public class BingoBoard {
    private int[][] board;
    private HashSet<Integer> markedNums;

    public BingoBoard(int[][] board) {
        this.board = board;
        markedNums = new HashSet<Integer>();
    }

    public void mark(int num) {
        markedNums.add(num);
    }

    public boolean hasWon() {
        for(int x = 0; x < board.length; x++) {
            for(int y = 0; y < board[0].length; y++) {
                if(markedNums.contains(board[x][y])) {
                    if(y == board[0].length - 1) {
                        return true;
                    }
                } else {
                    break;
                }
            }
        }

        for(int y = 0; y < board[0].length; y++) {
            for(int x = 0; x < board.length; x++) {
                if(markedNums.contains(board[x][y])) {
                    if(x == board.length - 1) {
                        return true;
                    }
                } else {
                    break;
                }
            }
        }

        return false;
    }
}