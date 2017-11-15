package ca.uqac.inf957.chess.agent;

import java.util.Random;

import ca.uqac.inf957.chess.Board;
// the irony
public class StupidAI extends Player {
    // dies roooooll
    private Random Dies = new Random(0);

    public StupidAI(int arg, Board board) {
	setColor(arg);
	this.playGround = board;
    }

    @Override
    public boolean move(Move mv) {
	// TODO: check the move
	// Make the move 
	return super.move(mv);
    }

    @Override
    public Move makeMove() {
	Move mv;
	int iniX = -1, iniY = -1, finX = -1, finY = -1;

	do {
	    iniX = Dies.nextInt(8);
	    iniY = Dies.nextInt(8);
	    finX = Dies.nextInt(8);
	    finY = Dies.nextInt(8);
	    mv = new Move(iniX, iniY, finX, finY);
	} while (!move(mv));

	System.out.printf("Votre coup Robot (%s): <%s>%n", this.getColorName(), mv.toString());
	return mv;
    }
}
