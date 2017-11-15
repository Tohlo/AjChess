package ca.uqac.inf957.aspect;

import ca.uqac.inf957.chess.Spot;
import ca.uqac.inf957.chess.agent.Move;
import ca.uqac.inf957.chess.agent.Player;
import ca.uqac.inf957.chess.piece.Bishop;
import ca.uqac.inf957.chess.piece.King;
import ca.uqac.inf957.chess.piece.Knight;
import ca.uqac.inf957.chess.piece.Pawn;
import ca.uqac.inf957.chess.piece.Piece;
import ca.uqac.inf957.chess.piece.Queen;
import ca.uqac.inf957.chess.piece.Rook;

public aspect CheckMoveJ {
	/** GLOBAL **/
	pointcut checkMove(Player player, Move mv): call(* Player.move(Move)) && target(player) && args(mv);

	boolean around(Player player, Move mv) : checkMove(player, mv) {
		// On récupère le plateau de jeu
		Spot[][] grid = player.getPlayGround().getGrid();
		Spot start = grid[mv.xI][mv.yI];
		Spot end = grid[mv.xF][mv.yF];

		// Si le joueur cible l'une de ses pièces
		if (start.isOccupied() && player.getColor() == start.getPiece().getPlayer()) {
			// Si c'est un pion, le traitement est un peu différent car son déplacement et sa prise ne suivent pas les mêmes règles
			if (start.getPiece().getClass().getName() == "ca.uqac.inf957.chess.piece.Pawn") {
				if ((!end.isOccupied() && start.getPiece().isMoveLegal(mv))
						|| (end.isOccupied() && player.getColor() != end.getPiece().getPlayer() && start.getPiece().checkPath(player, mv)) ) {
					return proceed(player, mv);
				}
			}
			// Si le mouvement est possible
			else if (start.getPiece().isMoveLegal(mv)) {
				// Si le mouvement est vers une case vide ou adverse
				if (!end.isOccupied() || player.getColor() != end.getPiece().getPlayer()) {
					// Si le chemin est libre
					if (start.getPiece().checkPath(player, mv)) {
						return proceed(player, mv);
					}
				}
			}
		}

		return false;
	}

	abstract boolean Piece.checkPath(Player player, Move mv);
	/** END GLOBAL **/

	/** BISHOP **/
	pointcut checkBishopMove(Move mv): execution(boolean Bishop.isMoveLegal(Move)) && args(mv);

	boolean around(Move mv) : checkBishopMove(mv) {
		// Le fou se déplace autant qu'il le veut en diagonale sur une partie non bloquée par une pièce
		return Math.abs(mv.xF - mv.xI) != 0 && Math.abs(mv.xF - mv.xI) == Math.abs(mv.yF - mv.yI);
	}

	boolean Bishop.checkPath(Player player, Move mv) {
		Spot[][] grid = player.getPlayGround().getGrid();

		// On vérifie que les cases sur la route soient bien libres
		boolean xWay = mv.xI - mv.xF > 0;
		boolean yWay = mv.yI - mv.yF > 0;

		// On ne teste pas la premiere case qui est celle de départ
		for (int i = mv.xI, j = mv.xF; i < mv.xF && j < mv.yF;) {
			if (xWay) {
				i = Math.max(--i, 0);
			}
			else {
				i = Math.min(++i, 7);
			}

			if (yWay) {
				j = Math.max(--j, 0);
			}
			else {
				j = Math.min(++j, 7);
			}

			if (grid[i][j].isOccupied()) {
				return false;
			}
		}
		return false;
	}
	/** END BISHOP **/

	/** KING **/
	pointcut checkKingMove(Move mv): execution(boolean King.isMoveLegal(Move)) && args(mv);

	boolean around(Move mv) : checkKingMove(mv) {
		// Le roi se déplace sur n'importe quel case autour de lui, sauf si un allié s'y trouve
		if (Math.abs(mv.xF - mv.xI) == 0 && Math.abs(mv.yF - mv.yI) == 0) {
			return false;
		}
		else if (Math.abs(mv.xF - mv.xI) <= 1 && Math.abs(mv.yF - mv.yI) <= 1) {
			return true;
		}
		return false;
	}

	boolean King.checkPath(Player player, Move mv) {
		return true;
	}
	/** END KING **/

	/** KNIGHT **/
	pointcut checkKnightMove(Move mv): execution(boolean Knight.isMoveLegal(Move)) && args(mv);

	boolean around(Move mv) : checkKnightMove(mv) {
		// Le cavalier se déplace en L, le mouvement doit donc avoir un écart de 2 et de 1 sur les deux composantes
		return ((Math.abs(mv.xF - mv.xI) == 2 && Math.abs(mv.yF - mv.yI) == 1) ||
				(Math.abs(mv.xF - mv.xI) == 1 && Math.abs(mv.yF - mv.yI) == 2));
	}

	boolean Knight.checkPath(Player player, Move mv) {
		return true;
	}
	/** END KNIGHT **/

	/** PAWN **/
	pointcut checkPawnMove(Piece piece, Move mv): execution(boolean Pawn.isMoveLegal(Move)) && target(piece) && args(mv);

	boolean around(Piece piece, Move mv) : checkPawnMove(piece, mv) {
		if (mv.xF == mv.xI) {
			// Dans le case, le pion ne peut se déplacer que d'une case, sauf s'il 
			// était sur sa case d'origine où il peut aller à deux cases 
			return (piece.getPlayer() == Player.BLACK) ?
					mv.yI - mv.yF == 1 || (mv.yI == 6 && mv.yF == 4):
						mv.yF - mv.yI == 1 || (mv.yI == 1 && mv.yF == 3);
		}
		return false;
	}

	boolean Pawn.checkPath(Player player, Move mv) {
		if (Math.abs(mv.xF - mv.xI) == 1) {
			return (player.getColor() == Player.BLACK) ? 
					mv.yI - mv.yF == 1: mv.yF - mv.yI == 1;
		}
		return false;
	}
	/** END PAWN **/

	/** QUEEN **/
	pointcut checkQueenMove(Move mv): execution(boolean Queen.isMoveLegal(Move)) && args(mv);

	boolean around(Move mv) : checkQueenMove(mv) {
		// La reine possède les déplacements d'une tour et d'un fou
		return (mv.xI == mv.xF && mv.yI != mv.yF ) || mv.yI == mv.yF || (Math.abs(mv.xF - mv.xI) != 0 && Math.abs(mv.xF - mv.xI) == Math.abs(mv.yF - mv.yI));
	}

	boolean Queen.checkPath(Player player, Move mv) {
		return true;
	}
	/** END QUEEN **/

	/** ROOK **/
	pointcut checkRookMove(Move mv): execution(boolean Rook.isMoveLegal(Move)) && args(mv);

	boolean around(Move mv) : checkRookMove(mv) {
		// La tour se déplace autant qu'elle le veut en ligne droite sur une partie non bloquée par une pièce
		return (mv.xI == mv.xF && mv.yI != mv.yF ) || mv.yI == mv.yF;
	}

	boolean Rook.checkPath(Player player, Move mv) {
		Spot[][] grid = player.getPlayGround().getGrid();

		// On vérifie que les cases sur la route soient bien libres
		if (mv.xI == mv.xF) {
			boolean yWay = mv.yI - mv.yF > 0;

			// On ne teste pas la premiere case qui est celle de départ
			for (int j = mv.yI; j < mv.yF;) {
				if (yWay) {
					j = Math.max(--j, 0);
				}
				else {
					j = Math.min(++j, 7);
				}

				if (grid[mv.xI][j].isOccupied()) {
					return false;
				}
			}
		}
		else {
			boolean xWay = mv.xI - mv.xF > 0;

			// On ne teste pas la premiere case qui est celle de départ
			for (int i = mv.yI; i < mv.yF;) {
				if (xWay) {
					i = Math.max(--i, 0);
				}
				else {
					i = Math.min(++i, 7);
				}

				if (grid[i][mv.yI].isOccupied()) {
					return false;
				}
			}
		}
		return false;
	}
	/** END ROOK **/
}
