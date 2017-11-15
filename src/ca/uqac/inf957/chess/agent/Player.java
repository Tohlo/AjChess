package ca.uqac.inf957.chess.agent;

import ca.uqac.inf957.chess.Board;

public abstract class Player {
    public static final int WHITE = 1;
    public static final int BLACK = 0;

    protected int Colour;
    protected Board playGround;

    public Board getPlayGround() {
	return playGround;
    }

    public void setPlayGround(Board playGround) {
	this.playGround = playGround;
    }

    public boolean move(Move mv) {
	playGround.movePiece(mv);
	return true;
    }

    public abstract Move makeMove();

    public String getColorName() {
	return (this.Colour == Player.WHITE) ? "White" : "Black";
    }

    public int getColor() {
	return this.Colour;
    }

    public void setColor(int arg) {
	this.Colour = arg;
    }
}
