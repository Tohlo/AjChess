package ca.uqac.inf957.chess.piece;

import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;

public class Queen extends Piece {

    public Queen(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "D" : "d");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
	    }
}