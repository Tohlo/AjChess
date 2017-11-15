package ca.uqac.inf957.chess.piece;

import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;

public class King extends Piece {

    public King(int player) {
	super(player);
    }

    @Override
    public String toString() {
	return ((this.player == Player.WHITE) ? "R" : "r");
    }

    @Override
    public boolean isMoveLegal(Move mv) {
	return false;
    }
}