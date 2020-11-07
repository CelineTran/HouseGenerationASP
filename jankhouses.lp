cneighbors(XX,YY,TYPE, COUNT) :- 
	COUNT =  {construction(XX-1,YY-1,TYPE);
					construction(XX,YY-1,TYPE);
					construction(XX+1,YY-1,TYPE);
					construction(XX-1,YY,TYPE);
					construction(XX+1,YY,TYPE);
					construction(XX-1,YY+1,TYPE);	
					construction(XX,YY+1,TYPE);
					construction(XX+1,YY+1,TYPE)},
					construction(XX,YY,_),					
					construction_type(TYPE).

  immediate_cneighbors(XX,YY,TYPE, COUNT) :- 
	COUNT =  {construction(XX,YY-1,TYPE);
					construction(XX-1,YY,TYPE);
					construction(XX+1,YY,TYPE);
					construction(XX,YY+1,TYPE)},
					construction(XX,YY,_),					
					construction_type(TYPE).

  construction_type(door;wall;floor;bed).

  %Places only on terrain types of grass or flower
  {construction(XX,YY,CONSTRUCTION_TYPE) : construction_type(CONSTRUCTION_TYPE)} 1 :- width(XX), 
        height(YY), not terrain(XX,YY, water), not terrain(XX,YY, tree), not terrain(XX,YY,bridge).

  %Should not place 2 doors side by side(also doesn't allow doors to touch diagonally which is theoretically allowed)
  :- construction(XX,YY,door), immediate_cneighbors(XX,YY,door, COUNT), COUNT>0.

  %Doors should open to grass or flowers, not water, bridges, or trees
  :- construction(XX,YY,door), immediate_cneighbors(XX,YY,water, COUNT), COUNT != 0.
  :- construction(XX,YY,door), immediate_cneighbors(XX,YY,bridge, COUNT), COUNT != 0.
  :- construction(XX,YY,door), immediate_cneighbors(XX,YY,tree, COUNT), COUNT!=0.
  :- construction(XX,YY,door), immediate_cneighbors(XX,YY,wall, COUNT), COUNT !=2.

  %A wall piece must touch (in cardinal directions) only 2 doors or walls
  :- construction(XX,YY,wall), immediate_cneighbors(XX,YY,wall, W_COUNT), 
        construction(XX,YY,wall), immediate_cneighbors(XX,YY,door, D_COUNT), W_COUNT + D_COUNT != 2.

:- construction(XX,YY, bed), cneighbors(XX,YY, bed, COUNT), COUNT > 0.
:- construction(XX,YY,bed), cneighbors(XX,YY,wall,COUNT), COUNT <7.
:- construction(XX,YY,bed), immediate_cneighbors(XX,YY,door,COUNT), COUNT !=1.

:-construction(XX,YY,wall), cneighbors(XX,YY,bed, COUNT), COUNT !=1.
:-construction(XX,YY,door), cneighbors(XX,YY,bed,COUNT), COUNT!=1.
:-construction(XX,YY,floor), cneighbors(XX,YY,bed,COUNT), COUNT!=1. 