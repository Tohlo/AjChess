package ca.uqac.inf957.aspect;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import ca.uqac.inf957.chess.Board;
import ca.uqac.inf957.chess.Game;
import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;
import ca.uqac.inf957.chess.piece.Piece;
import ca.uqac.inf957.chess.piece.Bishop;

public aspect MoveLogJ {


	pointcut saveMove(Move mv): call(* Board.movePiece(Move)) && args(mv);

	after(Move mv) : saveMove(mv) {
		BufferedWriter writer;

		try {
			writer = new BufferedWriter(new FileWriter("moveLog.txt", true));

			writer.write(mv.toString());
			writer.newLine();
			writer.close();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	pointcut resetLog(): call(* Board.setupChessBoard(..));
	
	after() : resetLog() {
		try {
			Files.deleteIfExists(Paths.get("moveLog.txt"));
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	pointcut displayBishop(Piece piece): execution(String Bishop.toString()) && target(piece);
	
	String around(Piece piece) : displayBishop(piece) {
		return ((piece.getPlayer() == Player.WHITE) ? "B" : "b");
	}
	
	pointcut correctColor(): execution(void Game.play());
	
	before() : correctColor() {
		System.out.println("Erratum : Black are smallcaps");
	}
}
